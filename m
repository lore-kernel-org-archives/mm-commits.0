Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD57A38FA1
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724478962; cv=none; b=kXfmrP63Ua4CwgLPQaUxSOCDjWQN3Ly7Rxx5GeSZhCdrWAuQP81PruNlIUyZclP3hNf0puSlQM07A6XvEeGiAEipfQdP5wwoX3QQZQlHlsI13Os/cqBBfX+EZwW/vCvoU5HjuXwhR9QTStTUVU1jDSaBZ8FDrfq9VaJD1gpCIcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724478962; c=relaxed/simple;
	bh=DwdFNwda6RJbgLQvFrDAEGaqyVTsO+UVLotHBOOsoCE=;
	h=Date:To:From:Subject:Message-Id; b=bu6RWa2zNmKB85QeL7JDqsC4hSmqEHZA9mpfhni8dmW+8JNRou9lG+VKqDf9aLCm3tQ5OCYyb6tT9aCRlhF4Uoipvv3XRcU2eKabhzrOa9LdmYbyfWStnGy3Kt3ipLG9mpDgm+uRB3AeWaSJz3KTgIi0o64oytR8noe9wamlmwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CTE/q1d3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CTE/q1d3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496FFC32781;
	Sat, 24 Aug 2024 05:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724478962;
	bh=DwdFNwda6RJbgLQvFrDAEGaqyVTsO+UVLotHBOOsoCE=;
	h=Date:To:From:Subject:From;
	b=CTE/q1d3jAzn3Lhy3s/DJi+9+dA6MeGuMtB5Vh0EtETDEX9Cxb8H8eqJ/EpxiV/Zj
	 iDJHE0/mAhP4xgxkUe0HB6s6QLvXCwoWjpc+zpJVMFKbxG62i65oO1Y7jyuigY6qWR
	 CpaJ0j/5xA6hFRgoMJONSYkopnwkY4kgTblHrfI4=
Date: Fri, 23 Aug 2024 22:56:01 -0700
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,swboyd@chromium.org,sashal@kernel.org,koct9i@gmail.com,alexis.lothore@bootlin.com,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch added to mm-nonmm-unstable branch
Message-Id: <20240824055602.496FFC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: remove find_module recursion and improve error reporting
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/decode_stacktrace.sh: remove find_module recursion and improve error reporting
Date: Fri, 23 Aug 2024 10:27:42 +0200

Patch series "scripts/decode_stacktrace.sh: improve error reporting and
usability", v2.

This small series improves usability of scripts/decode_stacktrace.sh by
improving the usage text and correctly reporting when modules are built
without debugging symbols.


This patch (of 3):

The find_module() function can fail for two reasons:

 * the module was not found
 * the module was found but without debugging info

In both cases the user is reported the same error:

   WARNING! Modules path isn't set, but is needed to parse this symbol

This is misleading in case the modules path is set correctly.

find_module() is currently implemented as a recursive function based on
global variables in order to check up to 4 different paths.  This is not
straightforward to read and even less to modify.

Besides, the debuginfo code at the beginning of find_module() is executed
identically every time the function is entered, i.e.  up to 4 times per
each module search due to recursion.

To be able to improve error reporting, first rewrite the find_module()
function to remove recursion.  The new version of the function iterates
over all the same (up to 4) paths as before and for each of them does the
same checks as before.  At the end of the iteration it is now able to
print an appropriate error message, so that has been moved from the caller
into find_module().

Finally, when the module is found but without debugging info, mention the
two Kconfig variables one needs to set in order to have the needed
debugging symbols.

Link: https://lkml.kernel.org/r/20240823-decode_stacktrace-find_module-improvements-v2-0-d7a57d35558b@bootlin.com
Link: https://lkml.kernel.org/r/20240823-decode_stacktrace-find_module-improvements-v2-1-d7a57d35558b@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   40 ++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting
+++ a/scripts/decode_stacktrace.sh
@@ -89,31 +89,32 @@ find_module() {
 		fi
 	fi
 
-	if [[ "$modpath" != "" ]] ; then
-		for fn in $(find "$modpath" -name "${module//_/[-_]}.ko*") ; do
-			if ${READELF} -WS "$fn" | grep -qwF .debug_line ; then
-				echo $fn
-				return
-			fi
-		done
-		return 1
-	fi
-
-	modpath=$(dirname "$vmlinux")
-	find_module && return
-
-	if [[ $release == "" ]] ; then
+	if [ -z $release ] ; then
 		release=$(gdb -ex 'print init_uts_ns.name.release' -ex 'quit' -quiet -batch "$vmlinux" 2>/dev/null | sed -n 's/\$1 = "\(.*\)".*/\1/p')
 	fi
+	if [ -n "${release}" ] ; then
+		release_dirs="/usr/lib/debug/lib/modules/$release /lib/modules/$release"
+	fi
 
-	for dn in {/usr/lib/debug,}/lib/modules/$release ; do
-		if [ -e "$dn" ] ; then
-			modpath="$dn"
-			find_module && return
+	found_without_debug_info=false
+	for dir in "$modpath" "$(dirname "$vmlinux")" ${release_dirs}; do
+		if [ -n "${dir}" ] && [ -e "${dir}" ]; then
+			for fn in $(find "$dir" -name "${module//_/[-_]}.ko*") ; do
+				if ${READELF} -WS "$fn" | grep -qwF .debug_line ; then
+					echo $fn
+					return
+				fi
+				found_without_debug_info=true
+			done
 		fi
 	done
 
-	modpath=""
+	if [[ ${found_without_debug_info} == true ]]; then
+		echo "WARNING! No debugging info in module ${module}, rebuild with DEBUG_KERNEL and DEBUG_INFO" >&2
+	else
+		echo "WARNING! Cannot find .ko for module ${module}, please pass a valid module path" >&2
+	fi
+
 	return 1
 }
 
@@ -131,7 +132,6 @@ parse_symbol() {
 	else
 		local objfile=$(find_module)
 		if [[ $objfile == "" ]] ; then
-			echo "WARNING! Modules path isn't set, but is needed to parse this symbol" >&2
 			return
 		fi
 		if [[ $aarray_support == true ]]; then
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are

scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch
scripts-decode_stacktracesh-clarify-command-line.patch
scripts-decode_stacktracesh-add-h-flag.patch

