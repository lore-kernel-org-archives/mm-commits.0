Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB701CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846611; cv=none; b=WIuAOKE8K/cgYRmzGxsQg+WEcPj1a8YEYHd3tf85uH+ngcDySIgxpbyKWJ9wqGKo6MV17SENbQkxnnqJYSiOkqBmS/hpstaGGOte+zsQFQYKwPByzBuNPOfYHwqApYLyp2USzpbZWMBQR2mMInQVWkfu0fY31Hf2nMAg80UIdv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846611; c=relaxed/simple;
	bh=aYyFM5dKKKrX369ItV0Yr2eQlzhljYDj60Jr8Ssv84c=;
	h=Date:To:From:Subject:Message-Id; b=iTUAh9hmxSHJEL0sNx1baKwQWCg7SnTCJVO/NtVt/xQQdxoNDlz7+sH1kHpLMuKqGHuVjs3Gaus3exsOZ4DPMbXuzUB8mdNw6wzBIlOKChs9vM1e01q61BnRYCi7V+nAlbsRE8BkJidoZ838+D3NZiROShXCi9NdUcSfxzIzOMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lA+kDHcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lA+kDHcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C870C4CEE4;
	Wed, 21 May 2025 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846610;
	bh=aYyFM5dKKKrX369ItV0Yr2eQlzhljYDj60Jr8Ssv84c=;
	h=Date:To:From:Subject:From;
	b=lA+kDHcTKXqboeZkZu3CE8IO2oczu///m8Wr8/IIf6q7i8A7V0//Zg0OASWgXsnv5
	 ST+dbjJbFHNvlKePKbBZRR9ORFodfQsrq4IZKzA5WC8unHXFWfmsvnB7U/Y3IAWIkd
	 bFPcbix/WIpm7uPoQtcHz9qT3Jpd/LqRDjKe+rh0=
Date: Wed, 21 May 2025 09:56:49 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch removed from -mm tree
Message-Id: <20250521165650.8C870C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: enter the runtime around kmsan_internal_memmove_metadata() call
has been removed from the -mm tree.  Its filename was
     kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


