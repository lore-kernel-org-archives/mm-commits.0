Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CA83090D5;
	Wed, 17 Dec 2025 20:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005043; cv=none; b=NNQYR4wqm0f3oIRUqYu5xeGVF/e7klzKisnoxwcc7mErLoFcjENUab/HGha4Q0iKdwR14Hn6LhjKH+pOlm8dbG75QwdkMUPf0fNxWDaJTTd2RAsPufTOgTzZctasAZvK/Gw1SFlv3DRzngZUVUFPq+9BFL4QjiHozYSu0biuNr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005043; c=relaxed/simple;
	bh=5j834NNQUN/BfiUU+Akg4hw2F8NZ4DC3ocKo0aivsSk=;
	h=Date:To:From:Subject:Message-Id; b=H68ZzLw2/DQdbJImtsUVpygZviDiiBS96HXqUab0yD8ZM8DB5Fj4Qy+R9nIBW2IeD/B7LvcsNGq/cUBhdiRly4qJoX+d5o3wurz2E39hXMa3tSgXEFuu0VTyAyaIolMsw4Eu6VYBikcIRkjvRryH+U9bri4zml9KzI1YG2cOJqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GicqngGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GicqngGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC03C4CEF5;
	Wed, 17 Dec 2025 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766005043;
	bh=5j834NNQUN/BfiUU+Akg4hw2F8NZ4DC3ocKo0aivsSk=;
	h=Date:To:From:Subject:From;
	b=GicqngGYe3yKlmT+4RGVGWvT8rjkYn966OOOEMsDrTaLeQfaT9kvSKTgVFA17GlSV
	 jkYkNk/FI2tULH0QGjyvB1sveWRzpGKGsfp3dXzsz0WK1rdutAL9TUuoiVp0L0Lfoy
	 +pEGonJYDEW4FcmvhQNaEHlGo4h+uOGuzFBG/bwA=
Date: Wed, 17 Dec 2025 12:57:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shivankg@amd.com,ryncsn@gmail.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,bijan311@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consider-non-anon-swap-cache-folios-in-folio_expected_ref_count.patch added to mm-hotfixes-unstable branch
Message-Id: <20251217205722.DDC03C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: consider non-anon swap cache folios in folio_expected_ref_count()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-consider-non-anon-swap-cache-folios-in-folio_expected_ref_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consider-non-anon-swap-cache-folios-in-folio_expected_ref_count.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bijan Tabatabai <bijan311@gmail.com>
Subject: mm: consider non-anon swap cache folios in folio_expected_ref_count()
Date: Tue, 16 Dec 2025 14:07:27 -0600

Currently, folio_expected_ref_count() only adds references for the swap
cache if the folio is anonymous.  However, according to the comment above
the definition of PG_swapcache in enum pageflags, shmem folios can also
have PG_swapcache set.  This patch makes sure references for the swap
cache are added if folio_test_swapcache(folio) is true.

This issue was found when trying to hot-unplug memory in a QEMU/KVM
virtual machine.  When initiating hot-unplug when most of the guest memory
is allocated, hot-unplug hangs partway through removal due to migration
failures.  The following message would be printed several times, and would
be printed again about every five seconds:

[   49.641309] migrating pfn b12f25 failed ret:7
[   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 index:0x7f404d925 pfn:0xb12f25
[   49.641311] aops:swap_aops
[   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1|reclaim|swapbacked|node=0|zone=3)
[   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8 0000000000000000
[   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff 0000000000000000
[   49.641315] page dumped because: migration failure

When debugging this, I found that these migration failures were due to
__migrate_folio() returning -EAGAIN for a small set of folios because the
expected reference count it calculates via folio_expected_ref_count() is
one less than the actual reference count of the folios.  Furthermore, all
of the affected folios were not anonymous, but had the PG_swapcache flag
set, inspiring this patch.  After applying this patch, the memory
hot-unplug behaves as expected.

I tested this on a machine running Ubuntu 24.04 with kernel version
6.8.0-90-generic and 64GB of memory.  The guest VM is managed by libvirt
and runs Ubuntu 24.04 with kernel version 6.18 (though the head of the
mm-unstable branch as a Dec 16, 2025 was also tested and behaves the same)
and 48GB of memory.  The libvirt XML definition for the VM can be found at
[1].  CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is set in the guest
kernel so the hot-pluggable memory is automatically onlined.

Below are the steps to reproduce this behavior:

1) Define and start and virtual machine
  host$ virsh -c qemu:///system define ./test_vm.xml # test_vm.xml from [1]
  host$ virsh -c qemu:///system start test_vm

2) Setup swap in the guest
  guest$ sudo fallocate -l 32G /swapfile
  guest$ sudo chmod 0600 /swapfile
  guest$ sudo mkswap /swapfile
  guest$ sudo swapon /swapfile

3) Use alloc_data [2] to allocate most of the remaining guest memory
  guest$ ./alloc_data 45

4) In a separate guest terminal, monitor the amount of used memory
  guest$ watch -n1 free -h

5) When alloc_data has finished allocating, initiate the memory
hot-unplug using the provided xml file [3]
  host$ virsh -c qemu:///system detach-device test_vm ./remove.xml --live

After initiating the memory hot-unplug, you should see the amount of
available memory in the guest decrease, and the amount of used swap data
increase.  If everything works as expected, when all of the memory is
unplugged, there should be around 8.5-9GB of data in swap.  If the
unplugging is unsuccessful, the amount of used swap data will settle below
that.  If that happens, you should be able to see log messages in dmesg
similar to the one posted above.

Link: https://lkml.kernel.org/r/20251216200727.2360228-1-bijan311@gmail.com
Link: https://github.com/BijanT/linux_patch_files/blob/main/test_vm.xml [1]
Link: https://github.com/BijanT/linux_patch_files/blob/main/alloc_data.c [2]
Link: https://github.com/BijanT/linux_patch_files/blob/main/remove.xml [3]
Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count calculation")
Signed-off-by: Bijan Tabatabai <bijan311@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-consider-non-anon-swap-cache-folios-in-folio_expected_ref_count
+++ a/include/linux/mm.h
@@ -2459,10 +2459,10 @@ static inline int folio_expected_ref_cou
 	if (WARN_ON_ONCE(page_has_type(&folio->page) && !folio_test_hugetlb(folio)))
 		return 0;
 
-	if (folio_test_anon(folio)) {
-		/* One reference per page from the swapcache. */
-		ref_count += folio_test_swapcache(folio) << order;
-	} else {
+	/* One reference per page from the swapcache. */
+	ref_count += folio_test_swapcache(folio) << order;
+
+	if (!folio_test_anon(folio)) {
 		/* One reference per page from the pagecache. */
 		ref_count += !!folio->mapping << order;
 		/* One reference from PG_private. */
_

Patches currently in -mm which might be from bijan311@gmail.com are

mm-consider-non-anon-swap-cache-folios-in-folio_expected_ref_count.patch

