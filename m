Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984333CB2EA
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646314; cv=none; b=p80qFb9FDQZnE1OBhXDR/bXIs9/usnLZlargtlmqd+NXKv9zBAX3G3NLduKkch+vpIRFZk4CncwQ5mlPlDZvq/kbtv3MyTtRHSD8BshMnSRT4avwcjKVCHsQTQctDxJTkHBST/IfzEo9Il1XD/ZY7MDlLu/bUaerC0h53TkcVUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646314; c=relaxed/simple;
	bh=6KdOQxVNUxwArH3oJHRgyTSBK1Ps/Vkht3ZVWZIASzo=;
	h=Date:To:From:Subject:Message-Id; b=uPZTbUOJLeiF0X0ZAnxpW5wTHWNkMfJcAdqzxh6asKY7KBpKoAke0qh2KwMfxqeo40Z8FeqYsyG3kf+iqLxCeNjJwbGMmiClL+VXAX6CKOhmZQquKfl9uptoL546uAJuuU6XClpT3gF2qjJgrBB6jVLL/xweGCibiKfTvBlQ9jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P5GsjLgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P5GsjLgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F069C19425;
	Wed,  4 Mar 2026 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646314;
	bh=6KdOQxVNUxwArH3oJHRgyTSBK1Ps/Vkht3ZVWZIASzo=;
	h=Date:To:From:Subject:From;
	b=P5GsjLgtyOevPmKQwaYs93pGqe3dWs5xlcCirNfjYwyldKaH+d3EiF9r1pEezLQja
	 oiQ71DV8MqtwBaxmIdnjV5xSkNsaeVOlYmTRni7bhtTZVAp/3dXFor94hv8ofmqv5r
	 vbjDIvufija6ue8u9+JFK5cb5QgWnRB3hmwiX8fs=
Date: Wed, 04 Mar 2026 09:45:13 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,lorenzo.stoakes@oracle.com,harry.yoo@oracle.com,hao.li@linux.dev,cl@linux.com,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-co-maintainer-and-reviewer-for-slab-allocator.patch removed from -mm tree
Message-Id: <20260304174514.5F069C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR
has been removed from the -mm tree.  Its filename was
     maintainers-add-co-maintainer-and-reviewer-for-slab-allocator.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR
Date: Mon, 2 Mar 2026 11:13:46 +0100

Promote Harry Yoo from reviewer to maintainer.  Harry's been involved in
slab development for multiple years now and doing a great job.

Add Hao Li as a new reviewer.  Hao has been doing very useful reviews for
a while now, so make it official and ensure the Cc's.

Link: https://lkml.kernel.org/r/20260302101345.36713-2-vbabka@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Hao Li <hao.li@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-co-maintainer-and-reviewer-for-slab-allocator
+++ a/MAINTAINERS
@@ -24361,11 +24361,12 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Harry Yoo <harry.yoo@oracle.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Hao Li <hao.li@linux.dev>
 R:	Christoph Lameter <cl@gentwo.org>
 R:	David Rientjes <rientjes@google.com>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
-R:	Harry Yoo <harry.yoo@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
_

Patches currently in -mm which might be from vbabka@kernel.org are

mm-page_alloc-effectively-disable-pcp-with-config_smp=n.patch
mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch
mm-page_alloc-remove-pcpu_spin_-wrappers.patch

