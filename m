Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F4F2BCF5
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 03:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755573612; cv=none; b=OczzxgRDza/ZBBeFTG6Fvq07JUCcP8qTbhV/g8RuZ9Uw+DtoKVJ3IoZj6ZDNzkNAhEWC1CnnXEXypTEVSonlE1HAw0HH2Tx+DzBzVhPpVezs6I/HyxmsnTZyXIg0L4fRZCOVZVSDWzmYJxLGX87MyA69EWg4HEzejt6ppCTquio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755573612; c=relaxed/simple;
	bh=YGoyBUctz5rLOuQKJ3KZakta2RERiSHb3AD+Jb7mr/s=;
	h=Date:To:From:Subject:Message-Id; b=hlZcMVvXmpr+T606FGsORAGlhjeHp9WyzMhZhCQcYkE8NPtWy01b03zU65iaPK9rybkkbdU8efgebifph1Ilprlsf0fuSFZwzc+NkSsLL+/trn3xXKlI+kRIMuW81GSCcCi6NAeScg/OaQFbVOdO6jDPNVt92t8J7emPk3VqiqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TvkBkIBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TvkBkIBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0CDC4CEF4;
	Tue, 19 Aug 2025 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755573610;
	bh=YGoyBUctz5rLOuQKJ3KZakta2RERiSHb3AD+Jb7mr/s=;
	h=Date:To:From:Subject:From;
	b=TvkBkIBLlBuo4dpf9TAeZeRAtpkdMXlonE79P0Pn1REmXoXd9KdB7edIlxiXIgszb
	 KZfT7xb+9Q2kBWxXYldPv8YMwZmv5JS2DV4Lyv2/S60fcU2NFrSfi3q0nM5QNITK0u
	 AXxcG2Ak9oTpBQqatob0WesF5EKKHRuYaCQjiwDU=
Date: Mon, 18 Aug 2025 20:20:10 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,jbohac@suse.cz,hpa@zytor.com,coxu@redhat.com,brgerst@gmail.com,bp@alien8.de,bhe@redhat.com,liaoyuanhong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-remove-redundant-0-value-initialization.patch added to mm-nonmm-unstable branch
Message-Id: <20250819032010.9A0CDC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/crash: remove redundant 0 value initialization
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-crash-remove-redundant-0-value-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-remove-redundant-0-value-initialization.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: x86/crash: remove redundant 0 value initialization
Date: Mon, 18 Aug 2025 20:35:28 +0800

The crash_mem struct is already zeroed by vzalloc(). It's redundant to
initialize cmem->nr_ranges to 0.

Link: https://lkml.kernel.org/r/20250818123530.635234-1-liaoyuanhong@vivo.com
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-crash-remove-redundant-0-value-initialization
+++ a/arch/x86/kernel/crash.c
@@ -172,7 +172,6 @@ static struct crash_mem *fill_up_crash_e
 		return NULL;
 
 	cmem->max_nr_ranges = nr_ranges;
-	cmem->nr_ranges = 0;
 
 	return cmem;
 }
@@ -332,7 +331,6 @@ int crash_setup_memmap_entries(struct ki
 		return -ENOMEM;
 
 	cmem->max_nr_ranges = nr_ranges;
-	cmem->nr_ranges = 0;
 
 	memset(&cmd, 0, sizeof(struct crash_memmap_data));
 	cmd.params = params;
_

Patches currently in -mm which might be from liaoyuanhong@vivo.com are

maple_tree-remove-redundant-semicolons.patch
lib-digsig-remove-unnecessary-memset.patch
x86-crash-remove-redundant-0-value-initialization.patch

