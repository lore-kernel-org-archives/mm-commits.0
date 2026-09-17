Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F59849E14C
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 23:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689448; cv=none; b=ZZiXvIhxQsx2wzQzRWOZq2CU1lXPc3QZ4VUo/QjMPytEU8LjyFJ20TPtk/nZBL9cjjL/fi466RyrawHFYaFY9HyYJu3Uex/EqHd0iIfveEvropOFpPR/BwzWbh4UNQi+5PA1fRexnHHXSk8nFOtSmx/rsvxf5A1GNTTgs5HKBA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689448; c=relaxed/simple;
	bh=/gC8n4aYBIeaZ+yt5/B+Bi9R20A84dv8fGViXjSkwDA=;
	h=Date:To:From:Subject:Message-Id; b=slERk+7T2AoNr1ysoP3mKtPVDK/xO6ghD6Kdk0EuSA+yMm3IchyJ0zbQAqTiNl/OSDM45X1Ouvbqb44cIgzqJ4oxHQeSNPllNOIl+bYT5+08lyDjCokJ5Nf/Wl+pAAcJIoQFeJaG3LZvx5QglBdPGQAEZxO/ZjfzcC278+Z3u5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6DwPppp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6DwPppp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3811F00893;
	Thu, 17 Sep 2026 23:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789689445;
	bh=/Lx0kx/9r6K4ay4Ju+u9D62j+KzKnyS1PlRfPp68c/Y=;
	h=Date:To:From:Subject;
	b=d6DwPpppDYa0iXi80iaFcusE7McLAfiAswN6pTEdCrGm0Ff1DJsM48jScHpDjrkDv
	 Fm7g4CziGlApRYey0yK6pl0esj3GOFIixQeTxpWUTNeHygYMqBo5F8Mla1yoKN6gyJ
	 wwgF2ZFZy4MSk4cXYv7yHdgv2tJF9msaI07PgjGI=
Date: Thu, 17 Sep 2026 16:57:25 -0700
To: mm-commits@vger.kernel.org,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch added to mm-new branch
Message-Id: <20260917235725.9F3811F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Lisa Wang <wyihan@google.com>
Subject: mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
Date: Thu, 17 Sep 2026 20:43:48 +0000

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console.  MF_DELAYED is then relayed to the
caller of truncate_error_folio() as MF_FAILED.  This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a memory
failure with MF_DELAYED will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-2-4b00856b5364@google.com
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Lisa Wang <wyihan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
---

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed
+++ a/mm/memory-failure.c
@@ -939,10 +939,12 @@ static int truncate_error_folio(struct f
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
-		if (err != 0)
+		if (err == MF_DELAYED)
+			ret = err;
+		else if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))
-			pr_info("%#lx: failed to release buffers\n", pfn);
+			pr_info("%#lx: Failed to release buffers\n", pfn);
 		else
 			ret = MF_RECOVERED;
 	} else {
_

Patches currently in -mm which might be from wyihan@google.com are

mm-memory_failure-clarify-the-mf_delayed-definition.patch
mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch
mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch
mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch
mm-selftests-add-shmem-into-memory-failure-test.patch

