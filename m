Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E6152E12
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248844; cv=none; b=pYl3+Rsah0cf2zfIWPHzs7/1/TA9Iu3zE3vid2TFqlpenwSaIYI5jjA40/wrJGXjaH965RQN2v81qHVZ0yUKow8DYI6JU9I+O4FvTBlrkJrvxqJaUV40FplxxQJ5iI4zAfHY8MtoBt/FFIjvRBJretJ2EgHZaYu9VCOO3BFM9CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248844; c=relaxed/simple;
	bh=R8g2INqYDctRvccBF1LnJxMOiTom4kj0C2bIdoNsVbQ=;
	h=Date:To:From:Subject:Message-Id; b=k5mZCQ4MI1UogzNlcIpbsjdGWio6uAH8Dntt6s1IUXxJWZtUHOETB/f5NkqjluB9Wa+Q38wGdBHdSCesJakVWdSH1YK/IY0MuSp+GDM/y3zqnsrJPHmaw5t40zOFdfyZR62iIIcjeXkRg4Cs8YrGqq4mzBLH0ddC/iOi57oosaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GgDZIKYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GgDZIKYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1205C4CEC2;
	Mon,  2 Sep 2024 03:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248843;
	bh=R8g2INqYDctRvccBF1LnJxMOiTom4kj0C2bIdoNsVbQ=;
	h=Date:To:From:Subject:From;
	b=GgDZIKYhkd57kly2rKG8uQDbXmV39mQuAmcTy7irDMu4mpaiA19g+r8uyBGZ6uNai
	 isiSbNPh4zOHCdET1ZQuIqQt2iCs7OVeNHv6mxXlRnb0tcMsr+jaXoyUv7SsvrMfW7
	 9m2mXUxKx3kxLy0gLn2k/QZ5VMhR5PJd7Q0+0ASA=
Date: Sun, 01 Sep 2024 20:47:23 -0700
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,swboyd@chromium.org,sashal@kernel.org,koct9i@gmail.com,alexis.lothore@bootlin.com,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch removed from -mm tree
Message-Id: <20240902034723.B1205C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: remove find_module recursion and improve error reporting
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


