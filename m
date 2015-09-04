From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-create-and-use-seq_show_option-for-escaping-fix2.patch removed from -mm
 tree
Date: Fri, 04 Sep 2015 15:24:40 -0700
Message-ID: <55ea1a28.Jq7EZ6oajAMEOOUQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190AbbIDWYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:24:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-create-and-use-seq_show_option-for-escaping-fix2
has been removed from the -mm tree.  Its filename was
     fs-create-and-use-seq_show_option-for-escaping-fix2.patch

This patch was dropped because it was folded into fs-create-and-use-seq_show_option-for-escaping.patch

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

clk_register_clkdev-handle-callers-needing-format-string.patch
fs-create-and-use-seq_show_option-for-escaping.patch

