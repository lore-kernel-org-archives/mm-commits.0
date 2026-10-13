Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB034825AA
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865930; cv=none; b=IAiDya/8aYmTLHYioU2fL/bpPRSXJO0a21an8POr7k6xw5ZWIHJf/jFeKuJxPIkQtwP+kDkNFVE3L8Tg1e02aFbiZdQpG34+Ex0w4JI3N0XEpfPe+TEeyoewTYCjd8pC85BLlDqsPWLsl1aq6HKoGxf7NUTpOo7luzWwUWPDpuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865930; c=relaxed/simple;
	bh=TSLjRyPtqudHlLwQ50j7na9Agnk8Xhv4zzNPGowP1YE=;
	h=Date:To:From:Subject:Message-Id; b=j32tghG0qsC+qH1jyWbk7lZYR4PsBZipmwADYaVJrFnYgiC2tzhniDByiVf1cMfU1Btr0Q/76Ziw+SFXQcxOaZSm5xG1PVuOoNuQOgG1G7gsbSPoB3LmaiHErAkEqmw9xwx1d19HzsnEpNAsF3IgPI8QIJtY+icKhy+Tim1OnsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cQQWUVvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cQQWUVvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AEC1F00893;
	Tue, 13 Oct 2026 04:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865929;
	bh=+sOzdbi+f1C/mpycn+KKXI5i9/hNmvME6lJMdsDQqpI=;
	h=Date:To:From:Subject;
	b=cQQWUVvy3RahbAB2naGgRsAfUQGeuM2S1Bcv5lQhWG/F7bPMnoNlWPZ7GFdSoUq+5
	 tfSmb6Aqs2v2DJuZUsaH0RqxRVVa13iYCIrme2qoM6o+EzG2hsUh3I3B/+wkabSxPM
	 0snCrtQ8dXbj3Sjko9X7jYAYnbT6IGxK9ZQBFqfQ=
Date: Mon, 12 Oct 2026 21:32:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-commit-hugepage_size-type-damon-filter.patch removed from -mm tree
Message-Id: <20261013043209.40AEC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: commit hugepage_size type damon filter
has been removed from the -mm tree.  Its filename was
     mm-damon-core-commit-hugepage_size-type-damon-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: commit hugepage_size type damon filter
Date: Tue, 15 Sep 2026 07:33:51 -0700

Extend data attribute probe filters commit logic for the new hugepage_size
filter type.  Since it needs to carry the size range of the hugepage,
update the logic to update the size range fields of the commit destination
filter struct.  While doing that, validate the given range and propagate
an error if it is invalid.  Add the error handling in the callers, too.

Link: https://lore.kernel.org/20260915143359.91472-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/core.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-commit-hugepage_size-type-damon-filter
+++ a/mm/damon/core.c
@@ -1818,7 +1818,7 @@ static int damon_commit_preps(struct dam
 	return 0;
 }
 
-static void damon_commit_filter(struct damon_filter *dst,
+static int damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
 	dst->type = src->type;
@@ -1828,23 +1828,33 @@ static void damon_commit_filter(struct d
 	case DAMON_FILTER_TYPE_MEMCG:
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
+	return 0;
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
 		struct damon_probe *src)
 {
 	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damon_for_each_filter_safe(dst_filter, next, dst) {
 		src_filter = damon_nth_filter(i++, src);
-		if (src_filter)
-			damon_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damon_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damon_destroy_filter(dst_filter);
+		}
 	}
 
 	damon_for_each_filter_safe(src_filter, next, src) {
@@ -1859,6 +1869,14 @@ static int damon_commit_filters(struct d
 		case DAMON_FILTER_TYPE_MEMCG:
 			new_filter->memcg_id = src_filter->memcg_id;
 			break;
+		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+			if (src_filter->range_max < src_filter->range_min) {
+				damon_destroy_filter(new_filter);
+				return -EINVAL;
+			}
+			new_filter->range_min = src_filter->range_min;
+			new_filter->range_max = src_filter->range_max;
+			break;
 		default:
 			break;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

