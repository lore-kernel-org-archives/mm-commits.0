Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3065B2561B
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 22:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721772698; cv=none; b=cQn1QFqdG1JT02Q5a34iMBBbOIs89uvES9LC1JJaXe4LXd1xpoia0udV8c5PKMrM1zLCI5GCFzFDTnWW9g8ByuEmMjFOQdZXtecT8SZzK8Do/25VUwznmst7VVL0/4FB7v2L4GqXUIBOD8mHdmRnek8o8ZVI2tAT/vya7rgB6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721772698; c=relaxed/simple;
	bh=b8a9T7w5HtqJEkslEkF+bPHWBXJGAFFhlYtfPWVrkJY=;
	h=Date:To:From:Subject:Message-Id; b=aRk1S59uZTzD9/Pj7rHLV9Ox7ys8g21LhDwsdyj3U4PY4c5kmjWmJUj3HQwXvgFaZP+uPX1MH7xtUj3ORZJ+SqZcz5oz0/a7BzkUvLT5eBvq1tpVqr1dwUMFeZX0SRb3/yh+hqwP6xvWccsKF7b1m6Kzp0iSyvNz77Y9u+FJ10M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZXkQw3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZXkQw3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77B8C4AF0A;
	Tue, 23 Jul 2024 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721772697;
	bh=b8a9T7w5HtqJEkslEkF+bPHWBXJGAFFhlYtfPWVrkJY=;
	h=Date:To:From:Subject:From;
	b=UZXkQw3Bi9Llr2PDJjTsd8rJOvW1M++Wy5yubZeI24cuzFcFtvjmZDg8gPzbbS5A7
	 IyNirWybRUj1ESPpMOUv0Z0HUqftNPj8J/fi1NNiKFoLLCHqAlQZb8WJEa6zmQKtHO
	 PJShTUwayi5eq2Ye82Gl9AXj0QZaULXQsmK0gzDg=
Date: Tue, 23 Jul 2024 15:11:37 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,ojeda@kernel.org,n.schier@avm.de,masahiroy@kernel.org,kvalo@kernel.org,jack@suse.cz,djwong@kernel.org,brauner@kernel.org,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-add-macro_checker-script-to-check-unused-parameters-in-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20240723221137.A77B8C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: add macro_checker script to check unused parameters in macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-add-macro_checker-script-to-check-unused-parameters-in-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-add-macro_checker-script-to-check-unused-parameters-in-macros.patch

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
Subject: scripts: add macro_checker script to check unused parameters in macros
Date: Tue, 23 Jul 2024 05:11:54 -0400

Recently, I saw a patch[1] on the ext4 mailing list regarding
the correction of a macro definition error. Jan mentioned
that "The bug in the macro is a really nasty trap...".
Because existing compilers are unable to detect
unused parameters in macro definitions. This inspired me
to write a script to check for unused parameters in
macro definitions and to run it.

Surprisingly, the script uncovered numerous issues across
various subsystems, including filesystems, drivers, and sound etc.

Some of these issues involved parameters that were accepted
but never used, for example:
	#define	XFS_DAENTER_DBS(mp,w)	\
	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 0))
where mp was unused.

While others are actual bugs.
For example:
	#define HAL_SEQ_WCSS_UMAC_CE0_SRC_REG(x) \
		(ab->hw_params.regs->hal_seq_wcss_umac_ce0_src_reg)
	#define HAL_SEQ_WCSS_UMAC_CE0_DST_REG(x) \
		(ab->hw_params.regs->hal_seq_wcss_umac_ce0_dst_reg)
	#define HAL_SEQ_WCSS_UMAC_CE1_SRC_REG(x) \
		(ab->hw_params.regs->hal_seq_wcss_umac_ce1_src_reg)
	#define HAL_SEQ_WCSS_UMAC_CE1_DST_REG(x) \
		(ab->hw_params.regs->hal_seq_wcss_umac_ce1_dst_reg)
where x was entirely unused, and instead, a local variable ab was used.

I have submitted patches[2-5] to fix some of these issues,
but due to the large number, many still remain unaddressed.
I believe that the kernel and matainers would benefit from
this script to check for unused parameters in macro definitions.

It should be noted that it may cause some false positives
in conditional compilation scenarios, such as
	#ifdef DEBUG
	static int debug(arg) {};
	#else
	#define debug(arg)
	#endif
So the caller needs to manually verify whether it is a true
issue. But this should be fine, because Maintainers should only
need to review their own subsystems, which typically results
in only a few reports.

[1]: https://patchwork.ozlabs.org/project/linux-ext4/patch/1717652596-58760-1-git-send-email-carrionbent@linux.alibaba.com/
[2]: https://lore.kernel.org/linux-xfs/20240721112701.212342-1-sunjunchao2870@gmail.com/
[3]: https://lore.kernel.org/linux-bcachefs/20240721123943.246705-1-sunjunchao2870@gmail.com/
[4]: https://sourceforge.net/p/linux-f2fs/mailman/message/58797811/
[5]: https://sourceforge.net/p/linux-f2fs/mailman/message/58797812/

Link: https://lkml.kernel.org/r/20240723091154.52458-1-sunjunchao2870@gmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Junchao Sun <sunjunchao2870@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/macro_checker.py |  101 +++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

--- /dev/null
+++ a/scripts/macro_checker.py
@@ -0,0 +1,101 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+# Author: Julian Sun <sunjunchao2870@gmail.com>
+
+""" Find macro definitions with unused parameters. """
+
+import argparse
+import os
+import re
+
+macro_pattern = r"#define\s+(\w+)\(([^)]*)\)"
+# below two vars were used to reduce false positives
+do_while0_pattern = r"\s*do\s*\{\s*\}\s*while\s*\(\s*0\s*\)"
+correct_macros = []
+
+def check_macro(macro_line, report):
+    match = re.match(macro_pattern, macro_line)
+    if match:
+        macro_def = re.sub(macro_pattern, '', macro_line)
+        identifier = match.group(1)
+        content = match.group(2)
+        arguments = [item.strip() for item in content.split(',') if item.strip()]
+
+        if (re.match(do_while0_pattern, macro_def)):
+            return
+
+        for arg in arguments:
+            # used to reduce false positives
+            if "..." in arg:
+                continue
+            if not arg in macro_def and report == False:
+                return
+            if not arg in macro_def and identifier not in correct_macros:
+                print(f"Argument {arg} is not used in function-line macro {identifier}")
+                return
+
+        correct_macros.append(identifier)
+
+
+# remove comment and whitespace
+def macro_strip(macro):
+    comment_pattern1 = r"\/\/*"
+    comment_pattern2 = r"\/\**\*\/"
+
+    macro = macro.strip()
+    macro = re.sub(comment_pattern1, '', macro)
+    macro = re.sub(comment_pattern2, '', macro)
+
+    return macro
+
+def file_check_macro(file_path, report):
+    # only check .c and .h file
+    if not file_path.endswith(".c") and not file_path.endswith(".h"):
+        return
+
+    with open(file_path, "r") as f:
+        while True:
+            line = f.readline()
+            if not line:
+                return
+
+            macro = re.match(macro_pattern, line)
+            if macro:
+                macro = macro_strip(macro.string)
+                while macro[-1] == '\\':
+                    macro = macro[0:-1]
+                    macro = macro.strip()
+                    macro += f.readline()
+                    macro = macro_strip(macro)
+                check_macro(macro, report)
+
+def get_correct_macros(path):
+    file_check_macro(path, False)
+
+def dir_check_macro(dir_path):
+
+    for dentry in os.listdir(dir_path):
+        path = os.path.join(dir_path, dentry)
+        if os.path.isdir(path):
+            dir_check_macro(path)
+        elif os.path.isfile(path):
+            get_correct_macros(path)
+            file_check_macro(path, True)
+
+
+def main():
+    parser = argparse.ArgumentParser()
+
+    parser.add_argument("path", type=str, help="The file or dir path that needs check")
+    args = parser.parse_args()
+
+    if os.path.isfile(args.path):
+        get_correct_macros(args.path)
+        file_check_macro(args.path, True)
+    elif os.path.isdir(args.path):
+        dir_check_macro(args.path)
+    else:
+        print(f"{args.path} doesn't exit or is neither a file nor a dir")
+
+if __name__ == "__main__":
+    main()
\ No newline at end of file
_

Patches currently in -mm which might be from sunjunchao2870@gmail.com are

scripts-add-macro_checker-script-to-check-unused-parameters-in-macros.patch

