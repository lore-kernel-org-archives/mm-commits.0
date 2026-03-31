Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195CA25782A
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917802; cv=none; b=PwhsQ2/hPIvfheSQZSFJKPEcD9FX5KnCB+pfFjPMRwB+FLn0ByYYylI6Aq1oXO9x6NJSW7mqI+rv1m4Q3IC/Lx3bkx5Jd7N5DfBDisReRpw0+dD8tzKq/RNhQEK3W7lJjL+nynWQl2thXxrUT4lmm1olh59pnhVW4ovZIyz/BOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917802; c=relaxed/simple;
	bh=4SqNR0oul2M488nzfxvcum+UTEvgCQdkDLhaZoV+qIE=;
	h=Date:To:From:Subject:Message-Id; b=QElRO3dYJiz5RXh8xn3jzViMK9jTRu3+azC87NaGd95FHJFP7KQpS20VE7aQKnCDM8Ow5Emi5mXciFJDoA0vwPALcVdkyAGwNVzRHNFqEuAfMX1jm4BEvEppYjwyGOSvC9VaIcMI6mm9xbACqp0OzfgEbG47hGebidvxfbQVwJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QEwnfGcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QEwnfGcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD063C4CEF7;
	Tue, 31 Mar 2026 00:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917802;
	bh=4SqNR0oul2M488nzfxvcum+UTEvgCQdkDLhaZoV+qIE=;
	h=Date:To:From:Subject:From;
	b=QEwnfGcJg1YfpGvatUST3t8Z5NTeWlrYgfBr4/9sXY+IiM+qjvkEKsMfbPyXLgHw6
	 tfqKAc8nAAKXRAdCB4fIWsPzJD4BbcHS44+2umfyaExqjnBQz6syJDTA5Pv2AI0nAy
	 Z26kGr1u1Ve0fkEhu4cDMLKESEUeeQBSXXxRZBn8=
Date: Mon, 30 Mar 2026 17:43:21 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch removed from -mm tree
Message-Id: <20260331004321.DD063C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hpet: replace deprecated mmap hook with mmap_prepare
has been removed from the -mm tree.  Its filename was
     hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: hpet: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:39 +0000

The f_op->mmap interface is deprecated, so update driver to use its
successor, mmap_prepare.

The driver previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Link: https://lkml.kernel.org/r/094c5fcfb2459a4f6d791b1fb852b01e252a44d4.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/char/hpet.c~hpet-replace-deprecated-mmap-hook-with-mmap_prepare
+++ a/drivers/char/hpet.c
@@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char
 }
 __setup("hpet_mmap=", hpet_mmap_enable);
 
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	struct hpet_dev *devp;
 	unsigned long addr;
 
@@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file,
 	if (addr & (PAGE_SIZE - 1))
 		return -ENOSYS;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	return vm_iomap_memory(vma, addr, PAGE_SIZE);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
+	return 0;
 }
 #else
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
 	return -ENOSYS;
 }
@@ -710,7 +712,7 @@ static const struct file_operations hpet
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
-	.mmap = hpet_mmap,
+	.mmap_prepare = hpet_mmap_prepare,
 };
 
 static int hpet_is_known(struct hpet_data *hdp)
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

