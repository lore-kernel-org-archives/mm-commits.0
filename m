Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EDB22F17B
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654228; cv=none; b=qIAlAgaSTRFWMg9K/75gc9z4T7liuA5n82U7zr97qNU5B3hBGW8IqiBMHTFYANcuIGPAtB5Hq1SVVaIKnGUvSys1gqMgXElCC+Za94Na32+3hmxJlFAoExhpvMTfeFBaxq1aPEP4Q2wcaBNz/lcU/ZqunIHL9AtRBbu9ARD4RTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654228; c=relaxed/simple;
	bh=tsMpL9J+XDsUCD8/duh2GgLG0FQi4EKz619gsmkXd9g=;
	h=Date:To:From:Subject:Message-Id; b=nbxrzGu69WxNeVfd8e3Rks7ts57Sa2DdDsr7kLkTKYQUP9+NRFJBltVCikKJFR22DVQRsZYNabwNHIzYcZi/DcD8+5hqrALMWJzRWUE4hHlvbNVkEJeBuUJXeKlsE3aM3beMxr4mxHr/nhxjtauKrOdXDELI4sFguSd2OCgh6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UDTYn+fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UDTYn+fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220CBC4CEE2;
	Wed,  7 May 2025 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746654228;
	bh=tsMpL9J+XDsUCD8/duh2GgLG0FQi4EKz619gsmkXd9g=;
	h=Date:To:From:Subject:From;
	b=UDTYn+fvV1XLDPih9qMpgkNziWsxc4jx5E3yI7Q6AFigWWIkNG2FIH3ZuhO4Ftlg8
	 k+FG729N7NDefBUKqlWNanKdbaq72uaKAOzNZgWiBOIfw+j6WMlBd6kum2JCKAnAM0
	 oV0DCxEMb/uPCmq5cUOreu5PKIfGon9CqzDeXv4k=
Date: Wed, 07 May 2025 14:43:47 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch added to mm-new branch
Message-Id: <20250507214348.220CBC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: enter the runtime around kmsan_internal_memmove_metadata() call
has been added to the -mm mm-new branch.  Its filename is
     kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: enter the runtime around kmsan_internal_memmove_metadata() call
Date: Wed, 7 May 2025 18:00:11 +0200

kmsan_internal_memmove_metadata() transitively calls stack_depot_save()
(via kmsan_internal_chain_origin() and kmsan_save_stack_with_flags()),
which may allocate memory.  Guard it with kmsan_enter_runtime() and
kmsan_leave_runtime() to avoid recursion.

This bug was spotted by CONFIG_WARN_CAPABILITY_ANALYSIS=y

Link: https://lkml.kernel.org/r/20250507160012.3311104-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kmsan/hooks.c~kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call
+++ a/mm/kmsan/hooks.c
@@ -275,8 +275,10 @@ void kmsan_copy_to_user(void __user *to,
 		 * Don't check anything, just copy the shadow of the copied
 		 * bytes.
 		 */
+		kmsan_enter_runtime();
 		kmsan_internal_memmove_metadata((void *)to, (void *)from,
 						to_copy - left);
+		kmsan_leave_runtime();
 	}
 	user_access_restore(ua_flags);
 }
_

Patches currently in -mm which might be from glider@google.com are

kmsan-apply-clang-format-to-files-mm-kmsan.patch
kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch
kmsan-drop-the-declaration-of-kmsan_save_stack.patch
kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch
kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch

