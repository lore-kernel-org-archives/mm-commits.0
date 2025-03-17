Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3A1A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188169; cv=none; b=s5GD05lL0OdPVstzuZH2C6SXhKa5HpASJ3Flfq519E9rUGWNcYQPDgFhz4s1Vt/VFQk9af0t8ycrjzbD5IY0gjTdVv0LuC8ttz8AVBBJSPAHFDYCAMcLNFZp4gqbHHpDUkaXsDl7qnC8Xcu7HIaIofAevnh2dNiQwaHRDLMedg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188169; c=relaxed/simple;
	bh=IbZ/LqR1/D2TByJPszOgaxuUVe2OtU+57sNSg/qqoiU=;
	h=Date:To:From:Subject:Message-Id; b=CrcVSKCtLMFxzjG01SEKSJuXF+aqUysgx6Gl8vh/s06VXBSMgf/Az4XXe2uriOdxYYmhFcq5dVaHdcuIQPJ0tpAS7WrLS4hxlUy+u5iaj8TS7MYZsWompMh8DOLHvq71K7nOjoPW07MScvHt9QEoiiKSj/C11TwfBF/bSaPtokg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGRCP4pI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGRCP4pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE6CC4CEEC;
	Mon, 17 Mar 2025 05:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188169;
	bh=IbZ/LqR1/D2TByJPszOgaxuUVe2OtU+57sNSg/qqoiU=;
	h=Date:To:From:Subject:From;
	b=ZGRCP4pII92svgvf2qUMv1V7S819J4pbUe4C5/owDCSAgPu2JKJp5oly90s1lUbnJ
	 5CL1HFSBLrIufCcBTWjlJuuS2cVihP6y1JyGdyKMXKzXH96sIDR+SMYtQMOGsfSj+2
	 GKZPlgCaZaEXMAKDmNitcl1gZ+tl6w6KaCAMr8BA=
Date: Sun, 16 Mar 2025 22:09:28 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,wangweiyang2@huawei.com,vbabka@suse.cz,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-ofp_peak_unset-instead-of-1.patch removed from -mm tree
Message-Id: <20250317050929.0CE6CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use OFP_PEAK_UNSET instead of -1
has been removed from the -mm tree.  Its filename was
     memcg-use-ofp_peak_unset-instead-of-1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: use OFP_PEAK_UNSET instead of -1
Date: Fri, 24 Jan 2025 07:35:11 +0000

Patch series "Some cleanup for memcg", v4.


This patch (of 4):

The 'OFP_PEAK_UNSET' has been defined, use it instead of '-1'.

Link: https://lkml.kernel.org/r/20250124073514.2375622-1-chenridong@huaweicloud.com
Link: https://lkml.kernel.org/r/20250124073514.2375622-2-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: David Finkel <davidf@vimeo.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-ofp_peak_unset-instead-of-1
+++ a/mm/memcontrol.c
@@ -4013,7 +4013,7 @@ static ssize_t peak_write(struct kernfs_
 			WRITE_ONCE(peer_ctx->value, usage);
 
 	/* initial write, register watcher */
-	if (ofp->value == -1)
+	if (ofp->value == OFP_PEAK_UNSET)
 		list_add(&ofp->list, watchers);
 
 	WRITE_ONCE(ofp->value, usage);
_

Patches currently in -mm which might be from chenridong@huawei.com are


