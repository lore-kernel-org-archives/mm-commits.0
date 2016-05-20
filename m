From: akpm@linux-foundation.org
Subject: [merged]
 scripts-decode_stacktracesh-handle-symbols-in-modules.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:02:27 -0700
Message-ID: <573f7b63./IEEyo+0aHkm7j3G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: handle symbols in modules
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-handle-symbols-in-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: scripts/decode_stacktrace.sh: handle symbols in modules

scripts/decode_stacktrace.sh presently displays module symbols as

	func+0x0ff/0x5153 [module]

Add a third argument: the pathname of a directory where the script should
look for the file module.ko so that the output appears as

	func (foo/bar.c:123) module

Without the argument or if the module file isn't found the script prints
such symbols as is without decoding.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   55 +++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff -puN scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-handle-symbols-in-modules scripts/decode_stacktrace.sh
--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-handle-symbols-in-modules
+++ a/scripts/decode_stacktrace.sh
@@ -2,15 +2,17 @@
 # (c) 2014, Sasha Levin <sasha.levin@oracle.com>
 #set -x
 
-if [[ $# != 2 ]]; then
+if [[ $# < 2 ]]; then
 	echo "Usage:"
-	echo "	$0 [vmlinux] [base path]"
+	echo "	$0 [vmlinux] [base path] [modules path]"
 	exit 1
 fi
 
 vmlinux=$1
 basepath=$2
+modpath=$3
 declare -A cache
+declare -A modcache
 
 parse_symbol() {
 	# The structure of symbol at this point is:
@@ -19,6 +21,17 @@ parse_symbol() {
 	# For example:
 	#   do_basic_setup+0x9c/0xbf
 
+	if [[ $module == "" ]] ; then
+		local objfile=$vmlinux
+	elif [[ "${modcache[$module]+isset}" == "isset" ]]; then
+		local objfile=${modcache[$module]}
+	else
+		[[ $modpath == "" ]] && return
+		local objfile=$(find "$modpath" -name $module.ko -print -quit)
+		[[ $objfile == "" ]] && return
+		modcache[$module]=$objfile
+	fi
+
 	# Remove the englobing parenthesis
 	symbol=${symbol#\(}
 	symbol=${symbol%\)}
@@ -29,11 +42,11 @@ parse_symbol() {
 	# Use 'nm vmlinux' to figure out the base address of said symbol.
 	# It's actually faster to call it every time than to load it
 	# all into bash.
-	if [[ "${cache[$name]+isset}" == "isset" ]]; then
-		local base_addr=${cache[$name]}
+	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
+		local base_addr=${cache[$module,$name]}
 	else
-		local base_addr=$(nm "$vmlinux" | grep -i ' t ' | awk "/ $name\$/ {print \$1}" | head -n1)
-		cache["$name"]="$base_addr"
+		local base_addr=$(nm "$objfile" | grep -i ' t ' | awk "/ $name\$/ {print \$1}" | head -n1)
+		cache[$module,$name]="$base_addr"
 	fi
 	# Let's start doing the math to get the exact address into the
 	# symbol. First, strip out the symbol total length.
@@ -48,12 +61,12 @@ parse_symbol() {
 	local address=$(printf "%x\n" "$expr")
 
 	# Pass it to addr2line to get filename and line number
-        # Could get more than one result
-	if [[ "${cache[$address]+isset}" == "isset" ]]; then
-		local code=${cache[$address]}
+	# Could get more than one result
+	if [[ "${cache[$module,$address]+isset}" == "isset" ]]; then
+		local code=${cache[$module,$address]}
 	else
-		local code=$(addr2line -i -e "$vmlinux" "$address")
-		cache[$address]=$code
+		local code=$(addr2line -i -e "$objfile" "$address")
+		cache[$module,$address]=$code
 	fi
 
 	# addr2line doesn't return a proper error code if it fails, so
@@ -105,13 +118,23 @@ handle_line() {
 		fi
 	done
 
-	# The symbol is the last element, process it
-	symbol=${words[$last]}
+	if [[ ${words[$last]} =~ \[([^]]+)\] ]]; then
+		module=${words[$last]}
+		module=${module#\[}
+		module=${module%\]}
+		symbol=${words[$last-1]}
+		unset words[$last-1]
+	else
+		# The symbol is the last element, process it
+		symbol=${words[$last]}
+		module=
+	fi
+
 	unset words[$last]
 	parse_symbol # modifies $symbol
 
 	# Add up the line number to the symbol
-	echo "${words[@]}" "$symbol"
+	echo "${words[@]}" "$symbol $module"
 }
 
 while read line; do
@@ -121,8 +144,8 @@ while read line; do
 		handle_line "$line"
 	# Is it a code line?
 	elif [[ $line == *Code:* ]]; then
-                decode_code "$line"
-        else
+		decode_code "$line"
+	else
 		# Nothing special in this line, show it as is
 		echo "$line"
 	fi
_

Patches currently in -mm which might be from koct9i@gmail.com are

mm-enable-rlimit_data-by-default-with-workaround-for-valgrind.patch
arch-defconfig-remove-config_resource_counters.patch

