Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555B8139D19
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248781; cv=none; b=MYGOyal597JFalXaTtZmCRhLs2TpkmppSiFgMMNa3P1PX3OpC0FMzKBOIA0kn4syX2n7fT0Lw+BVAiJ7d0tVaGeGMvhN8rQoB5aTeTm53cdRBQWSpuJ5nFIx1kq+ejyllPpPxeYQ7yzTuO3ub2sKWHe0TTm5oKUvAi8IZHMmvv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248781; c=relaxed/simple;
	bh=16+HXRJr8Gxg3YccUI3JOPzml6r7IpATTqH5qH7nOZ0=;
	h=Date:To:From:Subject:Message-Id; b=OCnxyY1gg5DEvWYgSmJT3bZFBq7lktzqS/9wtXFbbbHwkE+4WDKQ0RiU1EvjdSUecLQUNjzKKj//j5IoZC7+tBChYPVMyhr6MlUWTiGHaDPVpjrUhZZ15IbPidVOwXswSVU+3Hf/EtO4CI2o/dCaPjjCaLcjMpzZzGBvxpCJaDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OqAWn8sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OqAWn8sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C55C4CEC2;
	Mon,  2 Sep 2024 03:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248781;
	bh=16+HXRJr8Gxg3YccUI3JOPzml6r7IpATTqH5qH7nOZ0=;
	h=Date:To:From:Subject:From;
	b=OqAWn8spMN3xNbLN4YyUUzqV9384iPbUzJZjv137V0iCAAm2XqJzHsB4mMxMy+Xmo
	 S7MN8Aar0dh3jY67gAA+hWTRCLRjXdWETX2ddA/u9UWMFI8/dPCSwcJyPZC9VUMe/+
	 bfwatzdCcvGI1hdQhtiqqmcqKgeOHpJ/Wdb7oFNM=
Date: Sun, 01 Sep 2024 20:46:20 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,ojeda@kernel.org,n.schier@avm.de,masahiroy@kernel.org,kvalo@kernel.org,jack@suse.cz,djwong@kernel.org,brauner@kernel.org,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-add-macro_checker-script-to-check-unused-parameters-in-macros.patch removed from -mm tree
Message-Id: <20240902034621.23C55C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: add macro_checker script to check unused parameters in macros
has been removed from the -mm tree.  Its filename was
     scripts-add-macro_checker-script-to-check-unused-parameters-in-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[sunjunchao2870@gmail.com: reduce false positives]
  Link: https://lkml.kernel.org/r/20240726031310.254742-1-sunjunchao2870@gmail.com
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

 scripts/macro_checker.py |  131 +++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/scripts/macro_checker.py a/scripts/macro_checker.py
new file mode 100755
--- /dev/null
+++ a/scripts/macro_checker.py
@@ -0,0 +1,131 @@
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
+parser = argparse.ArgumentParser()
+
+parser.add_argument("path", type=str, help="The file or dir path that needs check")
+parser.add_argument("-v", "--verbose", action="store_true",
+                    help="Check conditional macros, but may lead to more false positives")
+args = parser.parse_args()
+
+macro_pattern = r"#define\s+(\w+)\(([^)]*)\)"
+# below vars were used to reduce false positives
+fp_patterns = [r"\s*do\s*\{\s*\}\s*while\s*\(\s*0\s*\)",
+               r"\(?0\)?", r"\(?1\)?"]
+correct_macros = []
+cond_compile_mark = "#if"
+cond_compile_end = "#endif"
+
+def check_macro(macro_line, report):
+    match = re.match(macro_pattern, macro_line)
+    if match:
+        macro_def = re.sub(macro_pattern, '', macro_line)
+        identifier = match.group(1)
+        content = match.group(2)
+        arguments = [item.strip() for item in content.split(',') if item.strip()]
+
+        macro_def = macro_def.strip()
+        if not macro_def:
+            return
+        # used to reduce false positives, like #define endfor_nexthops(rt) }
+        if len(macro_def) == 1:
+            return
+
+        for fp_pattern in fp_patterns:
+            if (re.match(fp_pattern, macro_def)):
+                return
+
+        for arg in arguments:
+            # used to reduce false positives
+            if "..." in arg:
+                return
+        for arg in arguments:
+            if not arg in macro_def and report == False:
+                return
+            # if there is a correct macro with the same name, do not report it.
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
+    # number of conditional compiling
+    cond_compile = 0
+    # only check .c and .h file
+    if not file_path.endswith(".c") and not file_path.endswith(".h"):
+        return
+
+    with open(file_path, "r") as f:
+        while True:
+            line = f.readline()
+            if not line:
+                break
+            line = line.strip()
+            if line.startswith(cond_compile_mark):
+                cond_compile += 1
+                continue
+            if line.startswith(cond_compile_end):
+                cond_compile -= 1
+                continue
+
+            macro = re.match(macro_pattern, line)
+            if macro:
+                macro = macro_strip(macro.string)
+                while macro[-1] == '\\':
+                    macro = macro[0:-1]
+                    macro = macro.strip()
+                    macro += f.readline()
+                    macro = macro_strip(macro)
+                if not args.verbose:
+                    if file_path.endswith(".c")  and cond_compile != 0:
+                        continue
+                    # 1 is for #ifdef xxx at the beginning of the header file
+                    if file_path.endswith(".h") and cond_compile != 1:
+                        continue
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


