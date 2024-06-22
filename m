Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E119C8BEC
	for <mm-commits@vger.kernel.org>; Sat, 22 Jun 2024 01:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719018315; cv=none; b=FvxVkfxB630TeD5o3DaGWZT9+61w4n2OI0w6J1/fXFNrER8TI0VwyU20qbMll/PgrHbnjmN+3uSOjQcfFyjKSoYTYVKA6pfUEiYha583mI18/pr2pN7NPKUjBXPzj5CaHCUCSTllsIrL3XeGgAy0tC7UPJg3yEVO5mIHm3gRcm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719018315; c=relaxed/simple;
	bh=nP/VImTUwd0J7K2/QBUdvVGhrFiLrvad4OVhm5Ql4kI=;
	h=Date:To:From:Subject:Message-Id; b=ThSWt1PEB1cvplt/FtCu1xPGvFtlrCyOoW5TF75jLinwR58zF+A3ceE5A6VhiGK42s3pQTrOEUQ6KBh9UvX2LUKAxAZ8erpa+dZifvvHy95ncrnJmhyFSdoxtoggQCVwVc1n5EK7O6ISioidLghhPLw1kob7ofu6KIXIEPTkPBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hFhEvqXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hFhEvqXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60164C2BBFC;
	Sat, 22 Jun 2024 01:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719018314;
	bh=nP/VImTUwd0J7K2/QBUdvVGhrFiLrvad4OVhm5Ql4kI=;
	h=Date:To:From:Subject:From;
	b=hFhEvqXhjNtIlLfZHBaei1mVW29zUwxaT2EQ10jbhqmqYN9swjfTjaXLQizIXzKnD
	 G47cSF8kgaYCD/mM9Kuy/mNge4MKrrXUC37pEw7VCwikxbuJoAx5U6xq2MgaOoTer1
	 4Cj6vd2ku1hAyyzIMJnMCa/w1KWaj3Pt7t0Yi51Y=
Date: Fri, 21 Jun 2024 18:05:13 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch added to mm-unstable branch
Message-Id: <20240622010514.60164C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not configured.
has been added to the -mm mm-unstable branch.  Its filename is
     turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not configured.
Date: Fri, 21 Jun 2024 14:12:24 -0400

If CONFIG_PTE_MARKER_UFFD_WP is disabled, then testing with test_uffdio_up
enables calling uffdio_regsiter with the flag UFFDIO_REGISTER_MODE_WP. 
The kernel ensures in vma_can_userfault() that if
CONFIG_PTE_MARKER_UFFD_WP is disabled, only allow the VM_UFFD_WP on
anonymous vmas.

Link: https://lkml.kernel.org/r/20240621181224.3881179-3-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/uffd-stress.c~turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -417,6 +417,9 @@ static void parse_test_type_arg(const ch
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 
+	if (test_type != TEST_ANON && !(features & UFFD_FEATURE_WP_UNPOPULATED))
+		test_uffdio_wp = false;
+
 	close(uffd);
 	uffd = -1;
 }
_

Patches currently in -mm which might be from audra@redhat.com are

fix-userfaultfd_api-to-return-einval-as-expected.patch
update-uffd-stress-to-handle-einval-for-unset-config-features.patch
turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

