Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D734405C4D
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779995757; cv=none; b=OAnYj44TPn9sBBc260TwlBDU8/sNTNyBh8lIXgkhqZ0SxhpuF43XiVp1QL5sAOR1VpdKQXGajk/YfYUf7xDfcXDDIrBAH/zGfH79PxCMEIL8/m9sEFAKjLbxIQVd05BQIjXatH1ywTIkX0oJXRwvLBoGJ0fafJvSEKBCYDUcRJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779995757; c=relaxed/simple;
	bh=hzSThKXqlEuwEWVvs/An3HlDu4d3daS8kHayoumkPVw=;
	h=Date:To:From:Subject:Message-Id; b=L589nrJ8jy7nulip6iYdFBWRmuvSfPMaqfSgH+UWeKFtcxLUIZ+rZmVL0QhiP/DiJRh/fec3TXv02RnvYcMZzUJRDoCdEgpit8rBZstyysKSlYqbjJanB9DqTp1D2HFKSayQm5BMyG5UEsg/IvEOqzWvUspv5b1R+VYIQww4mvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmzJ/0oc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmzJ/0oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C805E1F00A3C;
	Thu, 28 May 2026 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779995755;
	bh=bf5+Na+nKJ3DDIFMdlZKxiq0+iQOdsTE1+rebuk3F0Y=;
	h=Date:To:From:Subject;
	b=dmzJ/0ocm1IMYtS4fmbO+OalGR8MtD9wzILWq9aGYAJFHDoqXevmPbnjKJyeYZ2Tp
	 To+hph784Ho143eT4crXQReJ6IDwar3QWQMVPIhm0xxkeSwh75M2du9JnTnONzjcp3
	 7prX6KOLHA6TV93bloMJpBnF/R3eGM9jT4wSudCk=
Date: Thu, 28 May 2026 12:15:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,akpm@linux-foundation.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch removed from -mm tree
Message-Id: <20260528191555.C805E1F00A3C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/slabinfo: remove redundant slab->partial assignment
has been removed from the -mm tree.  Its filename was
     tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: tools/mm/slabinfo: remove redundant slab->partial assignment
Date: Mon, 18 May 2026 14:21:59 +0800

slab->partial is assigned by get_obj("partial") and then immediately
overwritten by get_obj_and_str("partial", &t).  Remove the first redundant
assignment.

Link: https://lore.kernel.org/20260518062159.80664-4-wangxuewen@kylinos.cn
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-remove-redundant-slab-partial-assignment
+++ a/tools/mm/slabinfo.c
@@ -1265,7 +1265,6 @@ static void read_slab_dir(void)
 			slab->objects_total = get_obj("objects_total");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
-			slab->partial = get_obj("partial");
 			slab->partial = get_obj_and_str("partial", &t);
 			decode_numa_list(slab->numa_partial, t);
 			free(t);
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch

