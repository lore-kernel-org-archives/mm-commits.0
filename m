Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FCF14265
	for <mm-commits@vger.kernel.org>; Sun,  9 Jun 2024 21:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717967201; cv=none; b=OrMldD0fwE2TX4JXhlBVAnPvKKP2Lwm5TmM+XXdCI8s6j0D3/Yxv96Uv1dgOj69ZAms6jinO3uenoJYGhlxeJS2v0dqx+xVTEfeNh5n4AaucatECv3gmROx2K+PzwwJCAtNiOPZosE2zBvkxU9P905ik8RG+BypafJ5gdXi+j+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717967201; c=relaxed/simple;
	bh=U2PhE00hiiXrgAGdXYCGGDAOBH6hV9WZX+pfmMEgYnM=;
	h=Date:To:From:Subject:Message-Id; b=BRuxdx5M8l8dpmCedD/pJF89TvMZdfcOuyjtD0qWShafv6Jh7FFbnQO6R61jWQAx7ufwh4h+8pBm6VTAPrXkPW+4wPmf/o8XQyuaIG0tAKnmxICyFtwZ13dLO66KCtoixW4cFGW168lU002z1XScae+3kiiSa61e6vr9eNtBkik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F0zxaNOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F0zxaNOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A016C2BD10;
	Sun,  9 Jun 2024 21:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717967201;
	bh=U2PhE00hiiXrgAGdXYCGGDAOBH6hV9WZX+pfmMEgYnM=;
	h=Date:To:From:Subject:From;
	b=F0zxaNOi8bvH2yBJH8F4hXZsagO3yy6aBBknATYKUvPFgXo0zD1GRuEs9jZzh8nQZ
	 0hQ+IgY6gbqh2O8HCbtlgiyPshRT0klzxnD5xZPeZUvGXz0nWdYdVVaqNCChGTjjJG
	 +OaQjcIgQJmpaWOzHgOQV/MPZDoSY+kIjHb5f9ko=
Date: Sun, 09 Jun 2024 14:06:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,parthiban.veerasooran@microchip.com,joel@jms.id.au,jk@ozlabs.org,eajames@linux.ibm.com,christian.gromm@microchip.com,alistair@popple.id.au,adobriyan@gmail.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240609210641.3A016C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: proc: remove usage of the deprecated ida_simple_xx() API
Date: Sat, 8 Jun 2024 16:34:20 +0200

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_max() is inclusive. So a -1 has been added when needed.

Link: https://lkml.kernel.org/r/ae10003feb87d240163d0854de95f09e1f00be7d.1717855701.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alistar Popple <alistair@popple.id.au>
Cc: Christian Gromm <christian.gromm@microchip.com>
Cc: Eddie James <eajames@linux.ibm.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/generic.c~proc-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/fs/proc/generic.c
@@ -202,8 +202,8 @@ int proc_alloc_inum(unsigned int *inum)
 {
 	int i;
 
-	i = ida_simple_get(&proc_inum_ida, 0, UINT_MAX - PROC_DYNAMIC_FIRST + 1,
-			   GFP_KERNEL);
+	i = ida_alloc_max(&proc_inum_ida, UINT_MAX - PROC_DYNAMIC_FIRST,
+			  GFP_KERNEL);
 	if (i < 0)
 		return i;
 
@@ -213,7 +213,7 @@ int proc_alloc_inum(unsigned int *inum)
 
 void proc_free_inum(unsigned int inum)
 {
-	ida_simple_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
+	ida_free(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
 }
 
 static int proc_misc_d_revalidate(struct dentry *dentry, unsigned int flags)
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

