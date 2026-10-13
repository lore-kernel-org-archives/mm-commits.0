Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8F543DED9
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865922; cv=none; b=LnEpSSU7X2xfIRnqIe6avCZwi4qK+gLgeWM/7YdCCzc8XWRk5jkAi1915tdsxMj/83Uizzu3ZF6jStCPBtiWtEbJMtbbNm9kuy3ykHJJhqEf2PMP0z2wGSh8TGB2ZTnDzjIyEo9BvfNLF81cEWms81XVaVjnoENnYRlUHihZJ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865922; c=relaxed/simple;
	bh=dFzyNno/iKqFh1VqEr5T+c9cmgCABaOoA+2IfU1R0MY=;
	h=Date:To:From:Subject:Message-Id; b=kgpW60zxH/9i6xLiRt2lTwGXf6ZWtKWzz7sQLm3WZtFIvEyM3MNp1wrnwFvuCzFnVMoJPtMvAWk8K3BUqYHssYfWvBwOg2HaAgkEX+dkKPiIAkrPs+FqEPdYQHKiPw94q2XckxU6uEoxFZ/Qst3W3+2ObcknxaRfxNPhi2HxbVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0vvo1+la; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0vvo1+la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3761F000FF;
	Tue, 13 Oct 2026 04:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865921;
	bh=wNE+9mTkMdSYU/isZ87qqaIP8K/VBhvzzdUE+T67x5Q=;
	h=Date:To:From:Subject;
	b=0vvo1+laZiK1hkmwPvKNgbXUwdLNGsToYEsJwPXCJMDEjE7gQ9c0xGvHX9Yjjk9PP
	 ZmIhpvN77kUocOvId8++z2LI9mXjc1E6ArsY9bRh4piCG/vtZaVKZlRz/kmqf0JcS4
	 gDFVysIX+oL+NF3eX4Qun2mP0m4h4NdB1lhLLlmM=
Date: Mon, 12 Oct 2026 21:32:00 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch removed from -mm tree
Message-Id: <20261013043201.3D3761F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: extract show_busy_info from vmalloc_info_show
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: extract show_busy_info from vmalloc_info_show
Date: Tue, 15 Sep 2026 10:43:32 +0800

Extract the busy vmap area iteration into show_busy_info, mirroring
the existing show_purge_info pattern.

Link: https://lore.kernel.org/20260915-vmalloc_study-v2-3-cc4dfe635e22@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show
+++ a/mm/vmalloc.c
@@ -5331,7 +5331,7 @@ static void show_purge_info(struct seq_f
 	}
 }
 
-static int vmalloc_info_show(struct seq_file *m, void *p)
+static void show_busy_info(struct seq_file *m)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
@@ -5401,12 +5401,18 @@ static int vmalloc_info_show(struct seq_
 		spin_unlock(&vn->busy.lock);
 	}
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		kfree(counters);
+}
+
+static int vmalloc_info_show(struct seq_file *m, void *p)
+{
+	show_busy_info(m);
+
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
 	show_purge_info(m);
-	if (IS_ENABLED(CONFIG_NUMA))
-		kfree(counters);
 	return 0;
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

