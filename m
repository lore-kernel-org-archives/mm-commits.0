From: akpm@linux-foundation.org
Subject: + alpha-remove-cast-from-void.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:36:26 -0700
Message-ID: <201009142236.o8EMaQ3Q022479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab0INWgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:36:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mfm@muteddisk.com, ink@jurassic.park.msu.ru, jbglaw@lug-owl.de, rth@twiddle.net


The patch titled
     alpha: remove cast from void*
has been added to the -mm tree.  Its filename is
     alpha-remove-cast-from-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: remove cast from void*
From: matt mooney <mfm@muteddisk.com>

Unnecessary cast from void* in assignment.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci-sysfs.c |    2 +-
 arch/alpha/kernel/srm_env.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/kernel/pci-sysfs.c~alpha-remove-cast-from-void arch/alpha/kernel/pci-sysfs.c
--- a/arch/alpha/kernel/pci-sysfs.c~alpha-remove-cast-from-void
+++ a/arch/alpha/kernel/pci-sysfs.c
@@ -66,7 +66,7 @@ static int pci_mmap_resource(struct kobj
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
-	struct resource *res = (struct resource *)attr->private;
+	struct resource *res = attr->private;
 	enum pci_mmap_state mmap_type;
 	struct pci_bus_region bar;
 	int i;
diff -puN arch/alpha/kernel/srm_env.c~alpha-remove-cast-from-void arch/alpha/kernel/srm_env.c
--- a/arch/alpha/kernel/srm_env.c~alpha-remove-cast-from-void
+++ a/arch/alpha/kernel/srm_env.c
@@ -87,7 +87,7 @@ static int srm_env_proc_show(struct seq_
 	srm_env_t	*entry;
 	char		*page;
 
-	entry = (srm_env_t *)m->private;
+	entry = m->private;
 	page = (char *)__get_free_page(GFP_USER);
 	if (!page)
 		return -ENOMEM;
_

Patches currently in -mm which might be from mfm@muteddisk.com are

alpha-remove-cast-from-void.patch

