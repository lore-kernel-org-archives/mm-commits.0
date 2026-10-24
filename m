Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832470;
	b=w/4PQa1nQkH85qy2aAUhkrCCKR33RF5yCdPKRsJ22nUtJCPXOcXk9o4jNZxx6kWGAL7E
	 AbfOIIcKNm8tq6B6TsADIHcrF1UjXfQ6uxBtDRLfwrKGpnF1JCA5gTygHNPxzoTz70IcB
	 3fD5/4W56nc/tebeQJocyVILKQNIOKlvg3r9YYNROXrijauHENKsjk/MDkBieeGNR0VCe
	 TUVU53pIXexAqIRCc1GqGBcnQvJG3EQ0nsUC05BzrMTTQDl2zOHoU18cufYXCwXTYzZeU
	 wLyeTCNw334uJJVg4mc2PBnTplAV70g80NOaN7hQJfkACBucroLku1E+qKQhSS1Cr6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832470;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bZEL66KfNvgTJBdm9/k9mq+y4BS6sQ2RH9+MsC3w8ug=;
	b=HJ2Y4XwSv0CvEZKbKeV2y1ew95Am+c3YiOuC97m1s8omvQcCacWfaMyf1AMF5sUtcXB9
	 gKKSJPV6nWZ7XDm1G6jM6HEtUSXIss23UkTAbMX/rflB7ILUtnVUgcAc5B7rPZYO5g5KD
	 N3JdZoCkj9beV7uVS5KJxcIsgjvZoPqTHm4ZWFMu6+veDHmF6W69dbVDv0t6XtqRQ/IBZ
	 WWrKQhGWvYOHIwOXUPDSPSTqXftJ03goVySEvtekIgG9kiLsuR5LADf+rWh8ZdoVVDMQ2
	 Bv3Y4oaAdHnFZDw+Y3h0tR6pIJN/kmqkcUQgbv1bUxa2iaKKiQ5FI9zZiCvZ3LQd8HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EpNulAFJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F69C606A31E
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EpNulAFJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC1C1F01828;
	Sat, 24 Oct 2026 09:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832470;
	bh=bZEL66KfNvgTJBdm9/k9mq+y4BS6sQ2RH9+MsC3w8ug=;
	h=Date:To:From:Subject;
	b=EpNulAFJbAY4VEHG+MyogFrItv84DX+XyELJ3kFcmE2sGwxT77J+toeXkmoR3CxTQ
	 WHsLljf3DPaYPzWPxURZKdX5KcpM0tWRaqct05W3jWW0cKMaOarQOwbldz7tP+7719
	 acXQEN13WMnh0Ixvn/kg8r6t6YySjHrRPwXYMrsU=
Date: Sat, 24 Oct 2026 02:01:09 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,enze.li@gmx.com,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes.patch removed from -mm tree
Message-Id: <20261024090109.DCC1C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: move hugetlb_sysfs_initialized into hugetlb_register_all_nodes()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb: move hugetlb_sysfs_initialized into hugetlb_register_all_nodes()
Date: Fri,  9 Oct 2026 22:20:10 +0800

hugetlb_sysfs_init() guards the "hugetlb_sysfs_initialized = true"
assignment with an #ifdef CONFIG_NUMA block, while the following
hugetlb_register_all_nodes() call is left unguarded and relies on the
empty !CONFIG_NUMA stub.

Move the assignment into the NUMA version of hugetlb_register_all_nodes(),
before it registers the online nodes, so the #ifdef in
hugetlb_sysfs_init() can go away.  Keep the !CONFIG_NUMA stub, so the call
site is unconditional in both configurations.

No functional change; this is an #ifdef cleanup.

Link: https://lore.kernel.org/20261009142010.552614-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Enze Li <enze.li@gmx.com>
---

 mm/hugetlb_sysfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_sysfs.c~mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes
+++ a/mm/hugetlb_sysfs.c
@@ -462,6 +462,8 @@ static void __init hugetlb_register_all_
 {
 	int nid;
 
+	hugetlb_sysfs_initialized = true;
+
 	for_each_online_node(nid)
 		hugetlb_register_node(node_devices[nid]);
 }
@@ -495,8 +497,5 @@ void __init hugetlb_sysfs_init(void)
 			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
 	}
 
-#ifdef CONFIG_NUMA
-	hugetlb_sysfs_initialized = true;
-#endif
 	hugetlb_register_all_nodes();
 }
_

Patches currently in -mm which might be from lienze@kylinos.cn are


