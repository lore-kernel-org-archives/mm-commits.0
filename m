From: akpm@linux-foundation.org
Subject: + fs-create-and-use-seq_show_option-for-escaping-fix2.patch added to -mm tree
Date: Tue, 11 Aug 2015 16:10:56 -0700
Message-ID: <55ca8100.JcrOpVz/WrhpF3+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbbHKXK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 19:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-create-and-use-seq_show_option-for-escaping-fix2
has been added to the -mm tree.  Its filename is
     fs-create-and-use-seq_show_option-for-escaping-fix2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-create-and-use-seq_show_option-for-escaping-fix2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-create-and-use-seq_show_option-for-escaping-fix2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs-create-and-use-seq_show_option-for-escaping-fix2

The buildbots noticed seq_show_option should be using const parameters.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_file.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/seq_file.h~fs-create-and-use-seq_show_option-for-escaping-fix2 include/linux/seq_file.h
--- a/include/linux/seq_file.h~fs-create-and-use-seq_show_option-for-escaping-fix2
+++ a/include/linux/seq_file.h
@@ -155,7 +155,8 @@ static inline struct user_namespace *seq
  * @name: the mount option name
  * @value: the mount option name's value, can be NULL
  */
-static inline void seq_show_option(struct seq_file *m, char *name, char *value)
+static inline void seq_show_option(struct seq_file *m, const char *name,
+				   const char *value)
 {
 	seq_putc(m, ',');
 	seq_escape(m, name, ",= \t\n\\");
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
user_ns-use-correct-check-for-single-threadedness.patch
capabilities-ambient-capabilities.patch
capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch
clk_register_clkdev-handle-callers-needing-format-string.patch
scripts-spellingtxt-adding-misspelled-word-for-check.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix2.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
lib-vsprintf-add-%pt-format-specifier.patch
lib-string_helpers-clarify-esc-arg-in-string_escape_mem.patch
lib-string_helpers-rename-esc-arg-to-only.patch
fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl.patch
fs-dont-dump-core-if-the-corefile-would-become-world-readable.patch
sysctl-fix-int-unsigned-long-assignments-in-int_min-case.patch
linux-next.patch

