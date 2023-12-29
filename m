Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C59E13AC4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DSJXw3fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296E4C433C8;
	Fri, 29 Dec 2023 20:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880060;
	bh=CKNObABRuoHSJ82zJRZEctlpUI9Pj18STLLP/KezdlE=;
	h=Date:To:From:Subject:From;
	b=DSJXw3fOb3DhdtwZ0UPqjbmgptAiA6sOrVG36tC837MeS+vUtp0QL50aiONjhiJIP
	 DVolsXdG1XrcfGlWsdwfgpeEcQekt/wLdC7Lmnmkmeb6kCLM4MT7ExOscbc0VC6CHR
	 ZZSJiYPGv/FEWXy1JjOkT4m2NjovkUCk4SPUuc3E=
Date: Fri, 29 Dec 2023 12:00:59 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,penguin-kernel@i-love.sakura.ne.jp,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-memset-free-track-in-qlink_free.patch removed from -mm tree
Message-Id: <20231229200100.296E4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: memset free track in qlink_free
has been removed from the -mm tree.  Its filename was
     kasan-memset-free-track-in-qlink_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: memset free track in qlink_free
Date: Tue, 19 Dec 2023 22:19:52 +0100

Instead of only zeroing out the stack depot handle when evicting the
free stack trace in qlink_free, zero out the whole track.

Do this just to produce a similar effect for alloc and free meta. The
other fields of the free track besides the stack trace handle are
considered invalid at this point anyway, so no harm in zeroing them out.

Link: https://lkml.kernel.org/r/db987c1cd011547e85353b0b9997de190c97e3e6.1703020707.git.andreyknvl@google.com
Fixes: 773688a6cb24 ("kasan: use stack_depot_put for Generic mode")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/quarantine.c~kasan-memset-free-track-in-qlink_free
+++ a/mm/kasan/quarantine.c
@@ -157,7 +157,7 @@ static void qlink_free(struct qlist_node
 	if (free_meta &&
 	    *(u8 *)kasan_mem_to_shadow(object) == KASAN_SLAB_FREETRACK) {
 		stack_depot_put(free_meta->free_track.stack);
-		free_meta->free_track.stack = 0;
+		__memset(&free_meta->free_track, 0, sizeof(free_meta->free_track));
 	}
 
 	/*
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

