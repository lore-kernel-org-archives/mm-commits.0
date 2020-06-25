From: akpm@linux-foundation.org
Subject: + scripts-decode_stacktrace-guess-path-to-modules.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 22:29:22 -0700
Message-ID: <20200625052922.YHkrh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgFYF3Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 01:29:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sashal@kernel.org, khlebnikov@yandex-team.ru


The patch titled
     Subject: scripts/decode_stacktrace.sh: guess path to modules
has been added to the -mm tree.  Its filename is
     scripts-decode_stacktrace-guess-path-to-modules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decode_stacktrace-guess-path-to-modules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decode_stacktrace-guess-path-to-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: scripts/decode_stacktrace.sh: guess path to modules

Try to find module in directory with vmlinux (for fresh build).  Then try
standard paths where debuginfo are usually placed.  Pick first file which
have elf section '.debug_line'.

Before:

$ echo 'tap_open+0x0/0x0 [tap]' |
  ./scripts/decode_stacktrace.sh /usr/lib/debug/boot/vmlinux-5.4.0-37-generic
WARNING! Modules path isn't set, but is needed to parse this symbol
tap_open+0x0/0x0 tap

After:

$ echo 'tap_open+0x0/0x0 [tap]' |
  ./scripts/decode_stacktrace.sh /usr/lib/debug/boot/vmlinux-5.4.0-37-generic
tap_open (drivers/net/tap.c:502) tap

Link: http://lkml.kernel.org/r/159282923068.248444.5461337458421616083.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   36 ++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-guess-path-to-modules
+++ a/scripts/decode_stacktrace.sh
@@ -12,9 +12,40 @@ fi
 vmlinux=$1
 basepath=${2-auto}
 modpath=$3
+release=""
+
 declare -A cache
 declare -A modcache
 
+find_module() {
+	if [[ "$modpath" != "" ]] ; then
+		for fn in $(find "$modpath" -name "${module//_/[-_]}.ko*") ; do
+			if readelf -WS "$fn" | grep -qwF .debug_line ; then
+				echo $fn
+				return
+			fi
+		done
+		return 1
+	fi
+
+	modpath=$(dirname "$vmlinux")
+	find_module && return
+
+	if [[ $release == "" ]] ; then
+		release=$(gdb -ex 'print init_uts_ns.name.release' -ex 'quit' -quiet -batch "$vmlinux" | sed -n 's/\$1 = "\(.*\)".*/\1/p')
+	fi
+
+	for dn in {/usr/lib/debug,}/lib/modules/$release ; do
+		if [ -e "$dn" ] ; then
+			modpath="$dn"
+			find_module && return
+		fi
+	done
+
+	modpath=""
+	return 1
+}
+
 parse_symbol() {
 	# The structure of symbol at this point is:
 	#   ([name]+[offset]/[total length])
@@ -27,12 +58,11 @@ parse_symbol() {
 	elif [[ "${modcache[$module]+isset}" == "isset" ]]; then
 		local objfile=${modcache[$module]}
 	else
-		if [[ $modpath == "" ]]; then
+		local objfile=$(find_module)
+		if [[ $objfile == "" ]] ; then
 			echo "WARNING! Modules path isn't set, but is needed to parse this symbol" >&2
 			return
 		fi
-		local objfile=$(find "$modpath" -name "${module//_/[-_]}.ko*" -print -quit)
-		[[ $objfile == "" ]] && return
 		modcache[$module]=$objfile
 	fi
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

scripts-decode_stacktrace-skip-missing-symbols.patch
scripts-decode_stacktrace-guess-basepath-if-not-specified.patch
scripts-decode_stacktrace-guess-path-to-modules.patch
scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch
kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
