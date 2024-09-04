Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF078B50
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423558; cv=none; b=YJ7GWRcsFhzSriJ/BymQBhmaXZd9B7Ce3lz6NYaRHL+/6mrHG4H0DekpAk++p84Tz3bPIoNjnJ58O/1JY4MJ4zO5/0yjfKYzuRJa975zVOWPkjvYfwtq+ly9skLatuAwEiaEo3LBBYGaUjvpxmHgyW6TxQd/BLJCm3Kn+4dcpRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423558; c=relaxed/simple;
	bh=FByUC8asrqo6AiJdb1h7/2b72IGyhcoaxU3qv5slQ48=;
	h=Date:To:From:Subject:Message-Id; b=GmuYJUGyJy4PJuqoaeLVcnKwVMWFIRdhN9Vjs303Wi73Ka5DNZLhxpRU8LU3QzAMRjRo+t9JfH7KdK6edRw8aFpB+rnuPx1tO4IytaMzdc3jtKKcReWsqcgJLKwD5sckmpXeWcuAdj+pJaJdI5sP6Vvn6q9Gy20iyxwe01/WWWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSSoHgYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSSoHgYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92A9C4CEC8;
	Wed,  4 Sep 2024 04:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423558;
	bh=FByUC8asrqo6AiJdb1h7/2b72IGyhcoaxU3qv5slQ48=;
	h=Date:To:From:Subject:From;
	b=YSSoHgYQ5HJcjid5lB8XI56TTD298+aDKWECbrsjNg7oUxCyKxLuMA8Dq4pswkdwT
	 KiWsqvbeFcxftdzZlrMC4xBb1NoZ+9UC6CWroPXdE0/QbaOHxkFEvFIJanlpW0S3SU
	 OkRfEMNvChuMfSK+NJ/P4oFUr10b9EpmC7x+2A/E=
Date: Tue, 03 Sep 2024 21:19:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-inline-munmap-operation-in-mmap_region.patch removed from -mm tree
Message-Id: <20240904041918.A92A9C4CEC8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: inline munmap operation in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-vma-inline-munmap-operation-in-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: inline munmap operation in mmap_region()
Date: Fri, 30 Aug 2024 00:00:48 -0400

mmap_region is already passed sanitized addr and len, so change the call
to do_vmi_munmap() to do_vmi_align_munmap() and inline the other checks.

The inlining of the function and checks is an intermediate step in the
series so future patches are easier to follow.

Link: https://lkml.kernel.org/r/20240830040101.822209-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/mmap.c~mm-vma-inline-munmap-operation-in-mmap_region
+++ a/mm/mmap.c
@@ -1388,12 +1388,15 @@ unsigned long mmap_region(struct file *f
 			return -ENOMEM;
 	}
 
-	/* Unmap any existing mapping in the area */
-	error = do_vmi_munmap(&vmi, mm, addr, len, uf, false);
-	if (error == -EPERM)
-		return error;
-	else if (error)
-		return -ENOMEM;
+	/* Find the first overlapping VMA */
+	vma = vma_find(&vmi, end);
+	if (vma) {
+		/* Unmap any existing mapping in the area */
+		error = do_vmi_align_munmap(&vmi, vma, mm, addr, end, uf, false);
+		if (error)
+			return error;
+		vma = NULL;
+	}
 
 	/*
 	 * Private writable mapping: check memory availability
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


