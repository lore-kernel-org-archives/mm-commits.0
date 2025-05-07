Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0CC290DB1
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 22:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746656661; cv=none; b=ZIY7s2wI5oU/alxlaFq9VUl7ycPLz7YY03JLSU+XEJdNLgApWtdgQOjUa4Xtv6l9YLqeKrlOvhCErvwK5/1nm+5FhG616xVYYdIVNW9GDG4M5q9hEAIFR+hgKnG0q6OWAD2K3k5JvPqtHdXdtOSE0RApa04WsWXUkrEAOrRejDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746656661; c=relaxed/simple;
	bh=bYNPe5L2MCf3Vuc+GQamjMqzdBTId/vO7UmHDAs8k6M=;
	h=Date:To:From:Subject:Message-Id; b=qwWsymT1TCTAXfj5Ks6VCkrfeKwrR7APC3ppPiScFr7CsnsBp3b2+zYmwBnl7qcRxmOKcAM4g4Zo1E7i3D+aNFhoCJJmTVU2/Kut+01modMiAy7kKcppLlt3dDaZhEI2J+4ePvKuDV0XoTbvQMQr9PZzlTjyVvde+TS05FTzDZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hfPRU0zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hfPRU0zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E2CC4CEE2;
	Wed,  7 May 2025 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746656660;
	bh=bYNPe5L2MCf3Vuc+GQamjMqzdBTId/vO7UmHDAs8k6M=;
	h=Date:To:From:Subject:From;
	b=hfPRU0zr4Uuzb6wior45OrsLGqR2iEPC/2T/Gk3tsbeIG95oof37Nh2c7l8/xC761
	 EMhkie6M013TomDg7N8ntXY/SYx8/eWaCrWYbO0g1tGPsuNTgCtslNJoEDc7gJsc36
	 YLEWhaDqcHMab2bblhObZA6eni1csTuyHFohyiPA=
Date: Wed, 07 May 2025 15:24:19 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,hch@infradead.org,david@redhat.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-vmalloc-co-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507222420.56E2CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add myself as vmalloc co-maintainer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-myself-as-vmalloc-co-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-vmalloc-co-maintainer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: MAINTAINERS: add myself as vmalloc co-maintainer
Date: Wed, 7 May 2025 17:02:57 +0200

I have been working on the vmalloc code for several years, contributing to
improvements and fixes.  Add myself as co-maintainer ("M") alongside
Andrew Morton.

Link: https://lkml.kernel.org/r/20250507150257.61485-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-myself-as-vmalloc-co-maintainer
+++ a/MAINTAINERS
@@ -25868,7 +25868,7 @@ F:	tools/testing/vsock/
 
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Uladzislau Rezki <urezki@gmail.com>
+M:	Uladzislau Rezki <urezki@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch
vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix.patch
lib-test_vmallocc-allow-built-in-execution.patch
maintainers-add-test_vmallocc-to-vmalloc-section.patch
vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

