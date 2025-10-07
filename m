Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C37B23816C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759872989; cv=none; b=IoZU7bTvk6hxEkPbIrQR7rRIx1Q6Y0Iq1Iujz0PirAkmBGp1KppxR0vQHbRu3pPnie8ECsPoZjrcntL/i212wN4XDlz8l4Nrx9Va2fZhq2WmY8ywQMIiscozuz9caBBg2ohA6Ryjcnlm355h9rNkJFS4FCOf3QN35ZZ7gJBu/XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759872989; c=relaxed/simple;
	bh=eM290995BjUcFJPGU/OddJj+WMBSf7IAR4a+OAcZDkw=;
	h=Date:To:From:Subject:Message-Id; b=jJgoCTNyJ4Ufjv9MrvR9XCMJzLmGq6L7Dq850+Vbr6FBIuLniTcD0k7PUvpKv3BHO5ps7wa44QrqrmvM36WbY0l5ZpXafGbtwrQb+HDDdJzHny/Z7uvm26Ck1YcaYSwBbjWTpkADTS7RsQ+dBDD68ebdMJiR0rLvUMNBCyoleFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WDIbXF1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WDIbXF1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEB8C4CEF1;
	Tue,  7 Oct 2025 21:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872988;
	bh=eM290995BjUcFJPGU/OddJj+WMBSf7IAR4a+OAcZDkw=;
	h=Date:To:From:Subject:From;
	b=WDIbXF1aW/PNM3+EOUaBfUB5iosKSUmaL9iPn4Gbdk3iv2zzDkXZO4AK4ZKXiFQ7E
	 KkV1emIbRTiXuDOh6WHsPsM07Y2O7buSAaz2qHkEFp3G6P1lLZT+y73l8S/eezo2xe
	 pADHDk0s5ehNgIg80ifMN9cVGd/zzCOOvtKM6PD4=
Date: Tue, 07 Oct 2025 14:36:28 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmalloc-remove-xfail-condition-check.patch added to mm-new branch
Message-Id: <20251007213628.8BEB8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc: remove xfail condition check
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmalloc-remove-xfail-condition-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmalloc-remove-xfail-condition-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: lib/test_vmalloc: remove xfail condition check
Date: Tue, 7 Oct 2025 14:20:27 +0200

A test marked with "xfail = true" is expected to fail but that does not
mean it is predetermined to fail.  Remove "xfail" condition check for
tests which pass successfully.

Link: https://lkml.kernel.org/r/20251007122035.56347-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmalloc-remove-xfail-condition-check
+++ a/lib/test_vmalloc.c
@@ -500,7 +500,7 @@ static int test_func(void *private)
 		for (j = 0; j < test_repeat_count; j++) {
 			ret = test_case_array[index].test_func();
 
-			if (!ret && !test_case_array[index].xfail)
+			if (!ret)
 				t->data[index].test_passed++;
 			else if (ret && test_case_array[index].xfail)
 				t->data[index].test_xfailed++;
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch

