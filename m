Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1DA2F1FEF
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766271275; cv=none; b=Q43hKwQxN+com0Gs+Dm2ZmxQYBZRY8FBjTCXGUoB5wY5pfir+79NtKM2tCyqNKGaqumSp4qMI3d2qRIaTik95Mzfdir+BxexRssZCEYu9HAZEoOfYUcs5NB0ElHBScpNM/AOLL0DJ8CXUNnLZD2d25T/TzkQem6mtNbNajBf704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766271275; c=relaxed/simple;
	bh=dLTmrqkgqqP02B7OhTG7uSAQcM9kP5hVoWjwkVEUcXw=;
	h=Date:To:From:Subject:Message-Id; b=cj+fnwdhvIntoTqs0ls8PuftfY9TITmHl7Qe4Zu92d9f9NOnaHtpwvQ2XTc+J4nDmVkBsC3ocQi9oe2OSMMRqGY2MsbbOUGp4GJv2JSkZURQjc92tSbEiWXmVn+/tWW9/76gLRquXqIpSNMfVspGFAAFDuBAu+2q1564PzzJ+SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pHmxSYuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pHmxSYuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7795C4CEF5;
	Sat, 20 Dec 2025 22:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766271274;
	bh=dLTmrqkgqqP02B7OhTG7uSAQcM9kP5hVoWjwkVEUcXw=;
	h=Date:To:From:Subject:From;
	b=pHmxSYuYwoeKXZVp8UGxXEcTJGT0pi5N1TwJCM0NqwjOgklUa6pVUMbSfMhMK7uUZ
	 56PILHgi/3y7WxFga2oytef5n3819IO8i2RmvHSDem64rAyf5pYwE+5EEUygSvNv46
	 pAiNwi1l2c/OZ0eUOOf0g4ngIsiFUU2oTghS703g=
Date: Sat, 20 Dec 2025 14:54:34 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,catalin.marinas@arm.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-print-out-debugging-message-if-required-for-kexec_load.patch added to mm-nonmm-unstable branch
Message-Id: <20251220225434.D7795C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: print out debugging message if required for kexec_load
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-print-out-debugging-message-if-required-for-kexec_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-print-out-debugging-message-if-required-for-kexec_load.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: print out debugging message if required for kexec_load
Date: Fri, 19 Dec 2025 17:31:33 +0800

The commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

As a result, when using '-d' for the kexec_load interface, print nothing
in the kernel space.

Since the segments debugging message has already been printed by the
user-space tool kexec-tools, it will not be printed here in the kernel
space.

And print out type/start/head of kimage and flags to help debug.

Link: https://lkml.kernel.org/r/20251219093134.2268620-4-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kexec.c~kexec-print-out-debugging-message-if-required-for-kexec_load
+++ a/kernel/kexec.c
@@ -166,6 +166,9 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("kexec_load: type:%u, start:0x%lx head:0x%lx flags:0x%lx\n",
+		      image->type, image->start, image->head, flags);
+
 	/* Install the new kernel and uninstall the old */
 	image = xchg(dest_image, image);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-replace-the-goto-out_unlock-with-out.patch
kexec-add-kexec-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

