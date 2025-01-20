Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A978BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337172; cv=none; b=DtGBh+fQ+trZo05Hto7P/dqgzECIiFHYTWELXyAFM1wmQY39FXEC32K8o15mxMAsdIxF0nYAr9/ChxF+F2nTQhQ/aqZyCjs2A5wrRBwsa2zxlqHrVNHQccGRqhBsUqZPLN0TbOIdyMYQoERP65H8YO0H4a2NMSTuATXPZyljMEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337172; c=relaxed/simple;
	bh=135Ls2hhTtFX8ZcAbcaSFuhjOw7TYmXu8J4wo+//6cM=;
	h=Date:To:From:Subject:Message-Id; b=oQkGQzK0MC7Zv+bd77rQ+dVaglTnxlaCyapv8GE0ap2HIAUtRt+9WM/w1uOlTM2RpFwKkPgg3OLYGk6GS/vu/RCzX8nm5tiKWb0fUUOueMiMlw2P41DtN40NLTGx6Eui1Bux1N0iE2cZ4seuI+A85z/Uqrk6ZvWxSZoWzbXRq2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TLbK28UY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TLbK28UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD53EC4CED6;
	Mon, 20 Jan 2025 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337171;
	bh=135Ls2hhTtFX8ZcAbcaSFuhjOw7TYmXu8J4wo+//6cM=;
	h=Date:To:From:Subject:From;
	b=TLbK28UYMpg0TIgj4KrBEQpYsV6wth5dAVE3KVTkJk+R8m5uhhUd18mgYhtKanffF
	 kFv6Ga5o/zA5Jcr8nVJlfWzFjwmjIujvEFujzlfYLiqjMGfSOJRCGpuWdkArK35K/n
	 jyOMnpcNZbTNnren3QQbCgwIKBIvK3RQVDguxpTQ=
Date: Sun, 19 Jan 2025 17:39:31 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-add-vm_warn_on_vmg-definition.patch removed from -mm tree
Message-Id: <20250120013931.BD53EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: add VM_WARN_ON_VMG definition
has been removed from the -mm tree.  Its filename was
     tools-add-vm_warn_on_vmg-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: tools: add VM_WARN_ON_VMG definition
Date: Thu, 16 Jan 2025 10:15:38 -0800

vma tests compilation yields the following error:

vma.c:732:9: error: implicit declaration of function ‘VM_WARN_ON_VMG’

Fix it by adding missing VM_WARN_ON_VMG() definition.

Link: https://lkml.kernel.org/r/20250116181538.759469-1-surenb@google.com
Fixes: e3a7ae85f87c ("mm/debug: prefer VM_WARN_ON_VMG() to report VMG debug warnings")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/vma/vma_internal.h~tools-add-vm_warn_on_vmg-definition
+++ a/tools/testing/vma/vma_internal.h
@@ -38,6 +38,7 @@ extern unsigned long dac_mmap_min_addr;
 
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
 
_

Patches currently in -mm which might be from surenb@google.com are


