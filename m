Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871B246BC6
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 04:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315637; cv=none; b=fwkFPzJ8crFfxl8YzofAOxe3ZbjC0163/wKaqAOe6zKCxv0uXesRAdvaCETREBh/swqJQ9ItGjlMQo/Z3CCGzcZaRYy5/duFrWwvvT1mDulb6m6n31Y89k5ushf4x9hSmL0TyVcCQOvMnNlh+mzVOd6AONIm24P22FVWfSZcY60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315637; c=relaxed/simple;
	bh=HmdNc7ToMPU/MoQLqOcrYoHxEKhe4SF1fKRWv18sdOE=;
	h=Date:To:From:Subject:Message-Id; b=CHLZ0mYPwbnEtwjM8Itai3ImxvZJzrYeQZrPRreaUKIpHcoBqIxPLCaOMULF4kSpCT1ElbWtqbcvJ4W0vwCfav5DvwX1kRBLDkrfKengChHqwfs58H1IFC24dmYHlhwxRJK3fLoc3xOgil7Rfwsc5+/H4gvqV1lJWzfDhxPlQWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXYQS3bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXYQS3bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6768C116B1;
	Wed,  5 Nov 2025 04:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762315636;
	bh=HmdNc7ToMPU/MoQLqOcrYoHxEKhe4SF1fKRWv18sdOE=;
	h=Date:To:From:Subject:From;
	b=KXYQS3bbFMKUTOrFN2Obe94s4ChC+4L8qFkqRS8q5XdRQ5D6wFayoR8GyewagMFWl
	 YaGxIC4fKYPx9rayYHm/A/zPd+2MNmPnGLz/dnm5lTsIs0ckdwffxFzAqb94iOHD50
	 rAEw3xGCI0uxFblsanawF3R4KIokt4VubMbxeCag=
Date: Tue, 04 Nov 2025 20:07:16 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch removed from -mm tree
Message-Id: <20251105040716.A6768C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file: fix the issue of mismatch between loop variable types
has been removed from the -mm tree.  Its filename was
     kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec_file: fix the issue of mismatch between loop variable types
Date: Mon, 3 Nov 2025 14:34:40 +0800

The type of the struct kimage member variable nr_segments is unsigned
long.  Correct the loop variable i and the print format specifier type.

Link: https://lkml.kernel.org/r/20251103063440.1681657-5-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/kexec_file.c~kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types
+++ a/kernel/kexec_file.c
@@ -366,7 +366,8 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 	int image_type = (flags & KEXEC_FILE_ON_CRASH) ?
 			 KEXEC_TYPE_CRASH : KEXEC_TYPE_DEFAULT;
 	struct kimage **dest_image, *image;
-	int ret = 0, i;
+	int ret = 0;
+	unsigned long i;
 
 	/* We only trust the superuser with rebooting the system. */
 	if (!kexec_load_permitted(image_type))
@@ -432,7 +433,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 		struct kexec_segment *ksegment;
 
 		ksegment = &image->segment[i];
-		kexec_dprintk("segment[%d]: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
+		kexec_dprintk("segment[%lu]: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
 			      i, ksegment->buf, ksegment->bufsz, ksegment->mem,
 			      ksegment->memsz);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are


