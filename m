From: akpm@linux-foundation.org
Subject: + arch-frv-mm-extablec-remove-unused-function.patch added to -mm
 tree
Date: Fri, 19 Dec 2014 15:54:34 -0800
Message-ID: <5494baba.UxzLKhF9oZmbPHEM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaLSXyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 18:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/frv/mm/extable.c:  remove unused function
has been added to the -mm tree.  Its filename is
     arch-frv-mm-extablec-remove-unused-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-frv-mm-extablec-remove-unused-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-frv-mm-extablec-remove-unused-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: arch/frv/mm/extable.c:  remove unused function

Remove the function search_one_table() that is not used anywhere.

This was partially found by using a static code analysis program called
cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/extable.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN arch/frv/mm/extable.c~arch-frv-mm-extablec-remove-unused-function arch/frv/mm/extable.c
--- a/arch/frv/mm/extable.c~arch-frv-mm-extablec-remove-unused-function
+++ a/arch/frv/mm/extable.c
@@ -10,29 +10,6 @@ extern const void __memset_end, __memset
 extern const void __memcpy_end, __memcpy_user_error_lr, __memcpy_user_error_handler;
 extern spinlock_t modlist_lock;
 
-/*****************************************************************************/
-/*
- *
- */
-static inline unsigned long search_one_table(const struct exception_table_entry *first,
-					     const struct exception_table_entry *last,
-					     unsigned long value)
-{
-        while (first <= last) {
-		const struct exception_table_entry __attribute__((aligned(8))) *mid;
-		long diff;
