Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B14D391838
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865984; cv=none; b=lTZQ5BvpVm3544DQkWv6JZKFh9d+/16/pLDBAe9/pAmdzlhUOmtVUC19pgz4qsdkKrCB3xoR7uBmrtszssuX891W+Wj6tYcdWTEb0+8ql1TLDYp6D/e4gMRSWpjn25rpzrTc/0Wy0IJPoDNf2+sxew4wbLV5y9XCAnwRZDKXXhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865984; c=relaxed/simple;
	bh=jXooGwQ0cKbbxS0P/EUEiGwW0h7+ziZFZyhS1UbvIGc=;
	h=Date:To:From:Subject:Message-Id; b=gUuCrjkP5iff43en0TzTM2awHsjRNds5C2Pxhab92LcQsUgF/S9m6deEVbFDooMO68zT+snfIodnx0W/pwxnYbEFFwnkxVJT0mRx6TMLz9xLRONxJe+laNlkX3D3jrgEfy1wTGI6Scq4vWk08pXfjIY1F2HTkf8FrSKJogGpP8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o4RHij5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o4RHij5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF92A1F000FF;
	Tue, 13 Oct 2026 04:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865982;
	bh=iudzYKIcvI2pf/tEeRXM27uUOoR5z8zROI2vp/+M/JI=;
	h=Date:To:From:Subject;
	b=o4RHij5kitcxHRUhJiknE4qh64I7JfSK9MgEURGAXFxJLdeBJquyPIWauqCXmCf6D
	 yBRQAKVrkeVjU3FddQPxgU+aqVhv59jWeGGfswfNwxHB5udyN40XR+prqPtqMnWEra
	 ihYrlIuAaADP7m1HoLXWlC3Ts86mgzCoIyeWY4pQ=
Date: Mon, 12 Oct 2026 21:33:02 -0700
To: mm-commits@vger.kernel.org,yu.c.zhang@linux.intel.com,xiaoyao.li@intel.com,vbabka@kernel.org,vannapurve@google.com,tabba@google.com,surenb@google.com,shuah@kernel.org,seanjc@google.com,rppt@kernel.org,rientjes@google.com,riel@redhat.com,pbonzini@redhat.com,nao.horiguchi@gmail.com,michael.roth@amd.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jiaqiyan@google.com,isaku.yamahata@intel.com,hughd@google.com,hidehiro.kawai.ez@hitachi.com,david@kernel.org,dave.hansen@linux.intel.com,baolin.wang@linux.alibaba.com,andi@firstfloor.org,ackerleytng@google.com,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch removed from -mm tree
Message-Id: <20261013043302.CF92A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: Update shmem handler to the MF_DELAYED definition
has been removed from the -mm tree.  Its filename was
     mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lisa Wang <wyihan@google.com>
Subject: mm: shmem: Update shmem handler to the MF_DELAYED definition
Date: Thu, 17 Sep 2026 20:43:49 +0000

To align with the definition of MF_DELAYED, update
shmem_error_remove_folio() to return MF_DELAYED.

shmem handles memory failures but defers the actual file truncation.  The
function's return value should therefore be MF_DELAYED to accurately
reflect the state.

Currently, this logical error does not cause a bug, because:

- For shmem folios, folio->private is not set.
- As a result, filemap_release_folio() is a no-op and returns true.
- This, in turn, causes truncate_error_folio() to incorrectly return
  MF_RECOVERED.
- The caller then treats MF_RECOVERED as a success condition, masking the
  issue.

The previous patch relays MF_DELAYED to the caller of
truncate_error_folio() before any logging, so returning MF_DELAYED from
shmem_error_remove_folio() will retain the original behavior of not adding
any logs.

The return value of truncate_error_folio() is consumed in action_result(),
which treats MF_DELAYED the same way as MF_RECOVERED, hence
action_result() also returns the same thing after this change.

Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-3-4b00856b5364@google.com
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

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-update-shmem-handler-to-the-mf_delayed-definition
+++ a/mm/shmem.c
@@ -5363,7 +5363,7 @@ static void __init shmem_destroy_inodeca
 static int shmem_error_remove_folio(struct address_space *mapping,
 				   struct folio *folio)
 {
-	return 0;
+	return MF_DELAYED;
 }
 
 static const struct address_space_operations shmem_aops = {
_

Patches currently in -mm which might be from wyihan@google.com are


