Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5873C1D41
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068069; cv=none; b=l6ysfyvfy9r8xorCbBub2Z79LabmaAUNzLx0bnLH9kvQCzcwRbqQEmcyR9jKZe1u+V/geW/nTJYWL7IzDXKhqDqSZsvLurR4ESDSOJSAgm488C99zv0q8OnIDj/O4mIGRUj6woLtJ41eCoOF/zjxskEDGl+r/Q+tvJmA8ZRz3/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068069; c=relaxed/simple;
	bh=yEHH5ggfsKiSWgfJ22sGkui+8u9B01lPJEW79Bh6Afo=;
	h=Date:To:From:Subject:Message-Id; b=iRK597lYaP9KFF/QW+OylzNi+zBPsar1vkYFVyuG+XTq9HFxBktpLrySZ1CrG6y62aVEaSTfyrV7Frz+NLENvYsW966CQB/kgk51ypaIXeleJ4jG8a2Q5xfg8FC+Pfx+2/3un3uTUKqzmkRaJ7qgOPHVdzy/XYn7IrLjOKnkgYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vgI+LOnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vgI+LOnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F901F00ACA;
	Fri,  7 Aug 2026 02:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068063;
	bh=KkvtOH+vHft8z0s2OUJAHTu7ImIA6l2oh+FhJTZHZys=;
	h=Date:To:From:Subject;
	b=vgI+LOntrqrHcUKd0g0odeqWc9TCtdiiYOoQBrMzDzWt+uTclkSB6cTnYf+xEJe5w
	 20AvG2mcDXQsmzGm/9NJ7YBsBpv//iDO3qSINhetLHWynUH8U8Eky/vXIsXsmf3Juq
	 QkeFFqI0P3DCyyeaYd20YvmiTOYYw2YHiUAf0x3Y=
Date: Thu, 06 Aug 2026 19:01:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damon_target-fields.patch removed from -mm tree
Message-Id: <20260807020103.A3F901F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damon_target fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damon_target-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damon_target fields
Date: Tue, 14 Jul 2026 07:35:35 -0700

'nr_regions', 'regions_list' and 'list' fields of damon_target are
intended to be used by only the DAMON core layer.  Those are mistakenly
not marked as private.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damon_target-fields
+++ a/include/linux/damon.h
@@ -79,9 +79,6 @@ struct damon_region {
 /**
  * struct damon_target - Represents a monitoring target.
  * @pid:		The PID of the virtual address space to monitor.
- * @nr_regions:		Number of monitoring target regions of this target.
- * @regions_list:	Head of the monitoring target regions of this target.
- * @list:		List head for siblings.
  * @obsolete:		Whether the commit destination target is obsolete.
  *
  * Each monitoring context could have multiple targets.  For example, a context
@@ -95,10 +92,14 @@ struct damon_region {
  */
 struct damon_target {
 	struct pid *pid;
+	bool obsolete;
+/* private: */
+	/* Number of monitoring target regions of this target. */
 	unsigned int nr_regions;
+	/* Head of the monitoring target regions of this target. */
 	struct list_head regions_list;
+	/* List head for siblings. */
 	struct list_head list;
-	bool obsolete;
 };
 
 /**
_

Patches currently in -mm which might be from sj@kernel.org are


