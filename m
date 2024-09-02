Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE3C8F6D;
	Mon,  2 Sep 2024 00:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238779; cv=none; b=uyiDs7z2ZnCbWGjkpyBVu9/Mh79bOyJ2o4sHZP1MvEfFPK40IobpqP0BiqCQ3d0wN7FSoA2MIidqxiw1uevdTeLnPXyRl0QJ7uyrGE2qjjHIZV1fN5rwnoZEO5JpH+yt2rVc6f854piPQ/XHoLnNcR48qbG0m/Q1DFS7E18ly8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238779; c=relaxed/simple;
	bh=ZUmM/ginxjLaQp6ZnOyQgF9ZkrJt+TFjRT+v6kBEw/w=;
	h=Date:To:From:Subject:Message-Id; b=ZCXP2ErvMKZcPTtIqoX6TLbtLLo5D4qAnk13ksjSbfN40K3+1I/gDbnLaffOBP59eifzbT486Oc8PyuDm12OSNM0NnbiL/SqZP1oCSe2Y/KqVOnW4fVxJzeDTv9OBDPpHnW5PpxNnw/y3/gCxmyawXAKiEyQbj3BBn9EPKh33SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dacljknU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dacljknU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848A6C4CEC3;
	Mon,  2 Sep 2024 00:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238779;
	bh=ZUmM/ginxjLaQp6ZnOyQgF9ZkrJt+TFjRT+v6kBEw/w=;
	h=Date:To:From:Subject:From;
	b=dacljknUN91fe8UI0skgVg5NCq9QjEfWzVbJjX2CQHIdwEyq4BA5jiRH7OU1SZDUl
	 rp7hRELJ4FI9ddlmXZkoByoXSScXyp07ZNLWl+AVzea6CFZXIbEahtlZRVpgUjsLNJ
	 AmOWqHnVp0a6FIGzdJMZwvnKEn50cEqTdJ6QPAjg=
Date: Sun, 01 Sep 2024 17:59:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sourabhjain@linux.ibm.com,hbathini@linux.ibm.com,eric_devolder@yahoo.com,ebiederm@xmission.com,bhe@redhat.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y.patch removed from -mm tree
Message-Id: <20240902005939.848A6C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y
has been removed from the -mm tree.  Its filename was
     kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y
Date: Mon, 5 Aug 2024 17:07:50 +0200

Fix the condition to exclude the elfcorehdr segment from the SHA digest
calculation.

The j iterator is an index into the output sha_regions[] array, not into
the input image->segment[] array.  Once it reaches
image->elfcorehdr_index, all subsequent segments are excluded.  Besides,
if the purgatory segment precedes the elfcorehdr segment, the elfcorehdr
may be wrongly included in the calculation.

Link: https://lkml.kernel.org/r/20240805150750.170739-1-petr.tesarik@suse.com
Fixes: f7cc804a9fd4 ("kexec: exclude elfcorehdr from the segment digest")
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_file.c~kexec_file-fix-elfcorehdr-digest-exclusion-when-config_crash_hotplug=y
+++ a/kernel/kexec_file.c
@@ -752,7 +752,7 @@ static int kexec_calculate_store_digests
 
 #ifdef CONFIG_CRASH_HOTPLUG
 		/* Exclude elfcorehdr segment to allow future changes via hotplug */
-		if (j == image->elfcorehdr_index)
+		if (i == image->elfcorehdr_index)
 			continue;
 #endif
 
_

Patches currently in -mm which might be from ptesarik@suse.com are


