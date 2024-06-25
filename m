Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00AC145336
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293215; cv=none; b=ofm6ZRh9fi3FnBdEASajJuD16I8Vx3VP+mxiUTujs7bhZvAvN7J2QQmGpCr/YWAnLFEs8IueNx7LQGB0qak0Je84fpclQJL5ClUkrjZNoNQi5GXrOfX9MRWoaC/HJuh5atUWvR3AQAaa6eLzifNUvhUg5eAhyvx7CJDOJQJAuC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293215; c=relaxed/simple;
	bh=UzlfrHPKoHNt8GVsKhaCe7l9+emsbzjTx2kZQnR9TGY=;
	h=Date:To:From:Subject:Message-Id; b=PjcrxWe3yDpyfVNyBeO0gtWoHfbUEG7q2PO4WfEdwYOnx4LNWCxI2AhvBl57EMSqY3B4kfuDvQ4mpmM5C/2yb6Pzl06z1rRvxFlFrjvsdiL/x9IcEZciDXPHxklhK6m7bdQWgTnDr54W0cxGlPSMxSAk4M4RFbXQoeR9WlQ1U1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z2nwbjFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z2nwbjFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6F4C32782;
	Tue, 25 Jun 2024 05:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293215;
	bh=UzlfrHPKoHNt8GVsKhaCe7l9+emsbzjTx2kZQnR9TGY=;
	h=Date:To:From:Subject:From;
	b=z2nwbjFSta5NFlWsWo66ZD4HGUam/V+v6ik4kAr66N8Wy2oE2gCXsMiqzbWChkehz
	 vK+q6JKZcTpj5qHq88PJM3n+OoV0HArE+6QueP3j8m+QAZKN0Cm1X+f4nyf+3cOtjW
	 8TFmrfM8Xpl3oVY9YxKullJnIXQXUW2HrV/oMGL0=
Date: Mon, 24 Jun 2024 22:26:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,parthiban.veerasooran@microchip.com,joel@jms.id.au,jk@ozlabs.org,eajames@linux.ibm.com,christian.gromm@microchip.com,alistair@popple.id.au,adobriyan@gmail.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch removed from -mm tree
Message-Id: <20240625052655.9A6F4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: remove usage of the deprecated ida_simple_xx() API
has been removed from the -mm tree.  Its filename was
     proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


