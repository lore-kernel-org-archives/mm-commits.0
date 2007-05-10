From: akpm@linux-foundation.org
Subject: + timer-revert-parenthesis-fix-in-tbase_get_deferrable-etc.patch added to -mm tree
Date: Thu, 10 May 2007 02:30:50 -0700
Message-ID: <200705100930.l4A9Uos5017246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805AbXEJJbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 05:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, oleg@tv-sign.ru, satyam.sharma@gmail.com, venkatesh.pallipadi@intel.com


The patch titled
     timer: revert parenthesis fix in tbase_get_deferrable() etc
has been added to the -mm tree.  Its filename is
     timer-revert-parenthesis-fix-in-tbase_get_deferrable-etc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timer: revert parenthesis fix in tbase_get_deferrable() etc
From: Jarek Poplawski <jarkao2@o2.pl>

> > On 09-05-2007 21:10, Pallipadi, Venkatesh wrote:
> > ...
> > > On a 64 bit system, converting pointer to int causes unnecessary
> > > compiler
> > > warning, and intermediate long conversion was to avoid that. I will have
> > > to rephrase my comment to remove 32 bit value and use int, as that is
> > > what
> > > the function returns.

So, this patch reverts all changes done by my previous patch.

I apologize for my wrong comment about "logical error" here.

Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/timer.c~timer-revert-parenthesis-fix-in-tbase_get_deferrable-etc kernel/timer.c
--- a/kernel/timer.c~timer-revert-parenthesis-fix-in-tbase_get_deferrable-etc
+++ a/kernel/timer.c
@@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
 {
-	return (unsigned int)((unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
 }
 
 static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
 {
-	return (tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG);
+	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = (tvec_base_t *)((unsigned long)timer->base |
-	                               TBASE_DEFERRABLE_FLAG);
+	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
+	                               TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void
 timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
 {
-	timer->base = (tvec_base_t *)((unsigned long)new_base |
+	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
 	                              tbase_get_deferrable(timer->base));
 }
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
timer-revert-parenthesis-fix-in-tbase_get_deferrable-etc.patch
ppp_generic-fix-lockdep-warning.patch
