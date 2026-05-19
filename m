Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BA22D7DF1;
	Tue, 19 May 2026 04:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779164503; cv=none; b=VBor83HLX9nvUsllbk+9owfKEhwoi3RggrpHOgvvuhq+ykf7aQ40Xp001Sp509pQ8vF+dbn7+/MkepEPO9bwS+PHKpRTY9IPR+GVwjlB2xjXZiBgAhKyzScE+zyjYmgOeY2OiR1gLaHPMb8mtHWWasa/Tgatil0EnAkJufN3YmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779164503; c=relaxed/simple;
	bh=RhnVCPPLfnjYRnj8ou9X6BWn68dqm94ppHHpqnsYxvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyplwvlREEdhF7c/aC9Uq2KEQENuthSagY/EYCumlpe5FnjqgTvM7f2bULQM8muOQ/ma7Zr/Ect9T8oBw63szG30TCvZKzL7jg0VbY8YebYnzgntV91YIP54iaPq1C/+8ZIzOEpHDfC9MpE+nxzz9Pt9eM1pH2QJuJQlYoJ8o/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6qjPAcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6qjPAcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486E1C2BCB3;
	Tue, 19 May 2026 04:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779164502;
	bh=RhnVCPPLfnjYRnj8ou9X6BWn68dqm94ppHHpqnsYxvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6qjPAcvnnPkkIOhjJdrXwkYOcrMR+tEmPxnLPw7HrgQws6c03pV8mqCFvZzRzHIO
	 Jk3MdCDki0ZCcnznHtuXX/Hi8Y4FlW/LWZUrJNjFhcnQj7uyawnxunnsGTf3xqHykk
	 pZK+sxarojCg2m1pd9QEDhgFUzkvndZQOBuNKv+AYxPiRbtdbG0s1PYpzhHoUz7iHs
	 6tk6eiv0pwJcL702RBUsMIdV2qQNXVa3HSANwepXbVJw7KVITrS/jeOABRxi+DqobY
	 r7FY93QNU94YaWIsuVPCZygJ9FVb++V2s7qi64c+HCPsFBL604s7QZsYXm7x8tvJxH
	 dMIRTsyt/x12Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: + mm-damon-sysfs-schemes-delete-tried-region-in-regions_rmdirs.patch added to mm-hotfixes-unstable branch
Date: Mon, 18 May 2026 21:21:19 -0700
Message-ID: <20260519042120.88205-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518195238.8FAE5C2BCB7@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

On Mon, 18 May 2026 12:52:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-damon-sysfs-schemes-delete-tried-region-in-regions_rmdirs.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-delete-tried-region-in-regions_rmdirs.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: SeongJae Park <sj@kernel.org>
> Subject: mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
> Date: Mon, 18 May 2026 08:25:58 -0700
> 
> DAMON sysfs maintains the DAMOS tried region directory objects via a
> linked list.  When the user requests refresh of the directories, DAMON
> sysfs removes all the region directories first, and then generate updated
> regions directory on the empty space.  The removal function
> (damon_sysfs_scheme_regions_rm_dirs()) only puts the kobj objects. 
> Deletion of the container region object from the linked list is done
> inside the kobj release callback function.
> 
> If somehow the callback invocation is delayed, the list will contain
> regions list that gonna be freed.  If the updated region directories
> creation is started in this situation, the list can be corrupted and
> use-after-free can happen.
> 
> Because the kobj objects are managed by only DAMON sysfs, the issue cannot
> happen in normal situation.  But, such delays can be made on kernels that
> built with CONFIG_DEBUG_KOBJECT_RELEASE.  On the kernel, the issue can
> indeed be reproduced like below.
> 
>     # damo start --damos_action stat
>     # cd /sys/kernel/mm/damon/admin/kdamonds/0/
>     # for i in {1..10}; do echo update_schemes_tried_regions > state; done
>     # dmesg | grep underflow
>     [   89.296152] refcount_t: underflow; use-after-free.
> 
> Fix the issue by removing the region object from the list when
> decrementing the reference count.
> 
> Also update damos_sysfs_populate_region_dir() to add the region object to
> the list only after the kobject_init_and_add() is success, so that fail of
> kobject_init_and_add() is not leaving the deallocated object on the list.
> 
> The issue was discovered [1] by Sashiko.
> 
> Link: https://lore.kernel.org/20260518152559.93038-1-sj@kernel.org
> Link: https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org [1]
> Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Cc: <stable@vger.kernel.org> # 6.2.x
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/damon/sysfs-schemes.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-delete-tried-region-in-regions_rmdirs
> +++ a/mm/damon/sysfs-schemes.c
[...]
> @@ -2930,12 +2929,16 @@ void damos_sysfs_populate_region_dir(str
>  	region->sz_filter_passed = sz_filter_passed;
>  	list_add_tail(&region->list, &sysfs_regions->regions_list);
>  	sysfs_regions->nr_regions++;
> +	sysfs_regions->nr_regions++;
>  	if (kobject_init_and_add(&region->kobj,
>  				&damon_sysfs_scheme_region_ktype,
>  				&sysfs_regions->kobj, "%d",
>  				sysfs_regions->nr_regions++)) {
>  		kobject_put(&region->kobj);
> +		return;
>  	}
> +	list_add_tail(&region->list, &sysfs_regions->regions_list);
> +	sysfs_regions->nr_regions++;
>  }

Seems the patch was not cleanly applicable on the mm-hotfixes-unstable branch,
and a mistake was made while resolving the conflict.

The list_add_tail() call and 'sysfs_regions->nr_regions++' at the beginning of
the above hunk should be removed, but somehow those are not removed.  Instead,
one more 'sysfs_regions->nr_regions++' is added.

Could you please replace this with the below attaching one?


Thanks,
SJ

=== >8 ===
From 138504786fe7e50ca1edf29f670d50dd861c0230 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Sat, 16 May 2026 14:10:40 -0700
Subject: [PATCH] mm/damon/sysfs-schemes: delete tried region in
 regions_rmdirs()

DAMON sysfs maintains the DAMOS tried region directory objects via a
linked list.  When the user requests refresh of the directories, DAMON
sysfs removes all the region directories first, and then generate
updated regions directory on the empty space.  The removal function
(damon_sysfs_scheme_regions_rm_dirs()) only puts the kobj objects.
Deletion of the container region object from the linked list is done
inside the kobj release callback function.

If somehow the callback invocation is delayed, the list will contain
regions list that gonna be freed.  If the updated region directories
creation is started in this situation, the list can be corrupted and
use-after-free can happen.

Because the kobj objects are managed by only DAMON sysfs, the issue
cannot happen in normal situation.  But, such delays can be made on
kernels that built with CONFIG_DEBUG_KOBJECT_RELEASE.  On the kernel,
the issue can indeed be reproduced like below.

    # damo start --damos_action stat
    # cd /sys/kernel/mm/damon/admin/kdamonds/0/
    # for i in {1..10}; do echo update_schemes_tried_regions > state; done
    # dmesg | grep underflow
    [   89.296152] refcount_t: underflow; use-after-free.

Fix the issue by removing the region object from the list when
decrementing the reference count.

Also update damos_sysfs_populate_region_dir() to add the region object
to the list only after the kobject_init_and_add() is success, so that
fail of kobject_init_and_add() is not leaving the deallocated object on
the list.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org

Link: https://lore.kernel.org/20260518152559.93038-1-sj@kernel.org
Link: https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org [1]
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 04746cbb33272..a8014780edae9 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -88,7 +88,6 @@ static void damon_sysfs_scheme_region_release(struct kobject *kobj)
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
 			struct damon_sysfs_scheme_region, kobj);
 
-	list_del(&region->list);
 	kfree(region);
 }
 
@@ -164,7 +163,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	struct damon_sysfs_scheme_region *r, *next;
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
-		/* release function deletes it from the list */
+		list_del(&r->list);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
@@ -2928,14 +2927,15 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++)) {
 		kobject_put(&region->kobj);
+		return;
 	}
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
 }
 
 int damon_sysfs_schemes_clear_regions(
-- 
2.47.3

