Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1C423DE
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 01:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722388669; cv=none; b=f2Qt6gqTnPMuS4cPBULnnRjmvAAjBfW/dE8cr0VWJOBzeEDAO6AXhKaXg5y+7XcdpeYfbtkF3a16iLy/ggqbkR+OjK5f6E3+gZ//+v07ADtlOwTpjwDF+Sn79kisFeR+o2XvTIxMd7ev8sL8ByWv3OyOZfmJBRnYbZPH1WFf1Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722388669; c=relaxed/simple;
	bh=GQp/k4u9pDREOMFbhJFx/LZjqKexyN9WK6cD9RjkP8M=;
	h=Date:To:From:Subject:Message-Id; b=qavS96XdWv+/0mqLzSlqUKgWyXvl3DGerX+awPTLBFQ00d+cqcmufq/iUqJcyl/x/HAA+ewt5ZhjzLLRRDvnNXTHR0B2dq5zZf3Mpe8r4FCyCz7uZ3jG4eEvaYkFIkHQsw7XoM+haRNx0XLnSXihfgep8w7cYk+qU4TUHHQCuBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iv6mcz4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iv6mcz4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E30C32782;
	Wed, 31 Jul 2024 01:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722388669;
	bh=GQp/k4u9pDREOMFbhJFx/LZjqKexyN9WK6cD9RjkP8M=;
	h=Date:To:From:Subject:From;
	b=Iv6mcz4kBBJ6iAar6cDf5UdpSG1TxvW00q6laT3Ivay78UwYBCf2pCMpVvqUPmCN2
	 iya8PFMqY9Av8J193tZ0mPniChxbBk6VvhOJOhsi9nlevDPbPJ9nfyhx4liSiaT+uH
	 0rngp9azAavQmNdlDK7b14mejPiP5XkubwuV7Ll4=
Date: Tue, 30 Jul 2024 18:17:48 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,ojeda@kernel.org,n.schier@avm.de,masahiroy@kernel.org,kvalo@kernel.org,jack@suse.cz,djwong@kernel.org,brauner@kernel.org,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-add-macro_checker-script-to-check-unused-parameters-in-macros-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240731011749.05E30C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: reduce false positives in the macro_checker script
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-add-macro_checker-script-to-check-unused-parameters-in-macros-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-add-macro_checker-script-to-check-unused-parameters-in-macros-fix.patch

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
From: Julian Sun <sunjunchao2870@gmail.com>
Subject: scripts: reduce false positives in the macro_checker script
Date: Thu, 25 Jul 2024 23:13:10 -0400

Reduce false positives in the macro_checker
in the following scenarios:
  1. Macro definitions with only a single character
  2. Macro definitions as (0) and (1)
  3. Macro definitions as empty

Also provide an option (-v) that alow users to control
whether or not to check conditional macros. When -v is
specified, conditional macros are checked; otherwise,
thet are not.

Before this patch:
	sjc@sjc:linux$ ./scripts/macro_checker.py  fs | wc -l
	99

After this patch:
	sjc@sjc:linux$ ./scripts/macro_checker.py  fs | wc -l
	11
	sjc@sjc:linux$ ./scripts/macro_checker.py  -v fs | wc -l
	31

Link: https://lkml.kernel.org/r/20240726031310.254742-1-sunjunchao2870@gmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/macro_checker.py |   50 +++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 10 deletions(-)

--- a/scripts/macro_checker.py~scripts-add-macro_checker-script-to-check-unused-parameters-in-macros-fix
+++ a/scripts/macro_checker.py
@@ -8,10 +8,20 @@ import argparse
 import os
 import re
 
+parser = argparse.ArgumentParser()
+
+parser.add_argument("path", type=str, help="The file or dir path that needs check")
+parser.add_argument("-v", "--verbose", action="store_true",
+                    help="Check conditional macros, but may lead to more false positives")
+args = parser.parse_args()
+
 macro_pattern = r"#define\s+(\w+)\(([^)]*)\)"
-# below two vars were used to reduce false positives
-do_while0_pattern = r"\s*do\s*\{\s*\}\s*while\s*\(\s*0\s*\)"
+# below vars were used to reduce false positives
+fp_patterns = [r"\s*do\s*\{\s*\}\s*while\s*\(\s*0\s*\)",
+               r"\(?0\)?", r"\(?1\)?"]
 correct_macros = []
+cond_compile_mark = "#if"
+cond_compile_end = "#endif"
 
 def check_macro(macro_line, report):
     match = re.match(macro_pattern, macro_line)
@@ -21,15 +31,25 @@ def check_macro(macro_line, report):
         content = match.group(2)
         arguments = [item.strip() for item in content.split(',') if item.strip()]
 
-        if (re.match(do_while0_pattern, macro_def)):
+        macro_def = macro_def.strip()
+        if not macro_def:
+            return
+        # used to reduce false positives, like #define endfor_nexthops(rt) }
+        if len(macro_def) == 1:
             return
 
+        for fp_pattern in fp_patterns:
+            if (re.match(fp_pattern, macro_def)):
+                return
+
         for arg in arguments:
             # used to reduce false positives
             if "..." in arg:
-                continue
+                return
+        for arg in arguments:
             if not arg in macro_def and report == False:
                 return
+            # if there is a correct macro with the same name, do not report it.
             if not arg in macro_def and identifier not in correct_macros:
                 print(f"Argument {arg} is not used in function-line macro {identifier}")
                 return
@@ -49,6 +69,8 @@ def macro_strip(macro):
     return macro
 
 def file_check_macro(file_path, report):
+    # number of conditional compiling
+    cond_compile = 0
     # only check .c and .h file
     if not file_path.endswith(".c") and not file_path.endswith(".h"):
         return
@@ -57,7 +79,14 @@ def file_check_macro(file_path, report):
         while True:
             line = f.readline()
             if not line:
-                return
+                break
+            line = line.strip()
+            if line.startswith(cond_compile_mark):
+                cond_compile += 1
+                continue
+            if line.startswith(cond_compile_end):
+                cond_compile -= 1
+                continue
 
             macro = re.match(macro_pattern, line)
             if macro:
@@ -67,6 +96,12 @@ def file_check_macro(file_path, report):
                     macro = macro.strip()
                     macro += f.readline()
                     macro = macro_strip(macro)
+                if not args.verbose:
+                    if file_path.endswith(".c")  and cond_compile != 0:
+                        continue
+                    # 1 is for #ifdef xxx at the beginning of the header file
+                    if file_path.endswith(".h") and cond_compile != 1:
+                        continue
                 check_macro(macro, report)
 
 def get_correct_macros(path):
@@ -84,11 +119,6 @@ def dir_check_macro(dir_path):
 
 
 def main():
-    parser = argparse.ArgumentParser()
-
-    parser.add_argument("path", type=str, help="The file or dir path that needs check")
-    args = parser.parse_args()
-
     if os.path.isfile(args.path):
         get_correct_macros(args.path)
         file_check_macro(args.path, True)
_

Patches currently in -mm which might be from sunjunchao2870@gmail.com are

scripts-add-macro_checker-script-to-check-unused-parameters-in-macros.patch
scripts-add-macro_checker-script-to-check-unused-parameters-in-macros-fix.patch

