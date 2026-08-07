Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94A3BB117
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068072; cv=none; b=jFo8R0tCMS7oII5QYXhRgG9AqQOhIA5QbS1aAXL5tZhukrKxTu0yZdvExM8q1OHvD72GIpCZ3xK6R03lI/opYgGHfFNiTc8l+5f8SozT2i04ZvSi6ap+i0++3wxJpYfWYBVdTplEZwflYqdzRQOovMO1XZpttiqOCAGVD2m6+mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068072; c=relaxed/simple;
	bh=fBUMv91onx+ad+qbzYpDsMPM7htcnGaRxni9hlFWZtA=;
	h=Date:To:From:Subject:Message-Id; b=ge8d1y1lw0uerlMDfpmKfhTMMfVpNlpLj4wF2Agkxeq3NvVQftyKqE9KLvmpGnCiidN6OS9t6DmnClc6algtFBMDidT2ZFQ51d2J1dXWV9/EeuuMeYQ0yD29svKV6GJb0bJSBfxVXacwIGhrDVNUSDLH1j/+ydZ6ACmAh04chDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jgG+yO1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jgG+yO1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10451F00A3A;
	Fri,  7 Aug 2026 02:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068069;
	bh=82RKllKBPs8cluSeAXk7rQtgWnmmF3VRb/u4+mAcvQg=;
	h=Date:To:From:Subject;
	b=jgG+yO1ANR937iuM87h8WbHLkqnqozKO9LvgBp+vOc7EVXKOgvFHIWsdXAhbyme7l
	 TbX2PMkf4G6LZ//VXE/ueCc0WHTWvQaAcgLfP/vf1zaYqYCbZSoG+0PKYoJcJ08HGy
	 CDYprEsotUv2ese5sbvLRf4sDO1oaDV0Y2mZGp2E=
Date: Thu, 06 Aug 2026 19:01:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damon_filter-fields.patch removed from -mm tree
Message-Id: <20260807020108.E10451F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damon_filter fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damon_filter-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damon_filter fields
Date: Tue, 14 Jul 2026 07:35:40 -0700

damon_filter->list is intended to be used by only the DAMON core layer. 
However, it is mistakenly not marked as private.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-8-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damon_filter-fields
+++ a/include/linux/damon.h
@@ -758,7 +758,6 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
- * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -767,6 +766,8 @@ struct damon_filter {
 	union {
 		u64 memcg_id;
 	};
+/* private: */
+	/* Siblings list. */
 	struct list_head list;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


