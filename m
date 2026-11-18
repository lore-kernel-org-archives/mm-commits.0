Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038509;
	b=zJCvUQE1JyLW8w8QLH+5zrsQWOwW2Wqi7Zg68J5BdJt0GgyyWSguM+TKRW4EMoB60psw
	 1OsuQ/SYmO838DgjzsRMltqbmxGS4hTaoJJi1ivN3Y3NHifmhdqVP8uAwiCptd8cy8cPC
	 HitocN6LkrDUKu7mK3Rbf+5T9QnuCs9WXL65FPTjPUp8fBN/fV9+e6XlLDLaMPrvIfLMG
	 0vkAejyTA2mUaFOzINlA4anwDb7q5bKm7VFNo2nOqd60hylTKIIm0pAFr/tL3mwiZ+xqT
	 a7M5dvsdi7V3PqtraakaaGmcO22xiPG4kdWwfonXaUAUvac/4LoJtdcvIJnhRIfYRYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038509;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Hu4eabpEarZy5KdormXmkyULV0C3qWVe8T2guI6y3Y4=;
	b=2at6uHo0UydCKOn5hYVpDHS8l0EsEcfqcDVlMBLHXhP5bJeFsmCOIh6WhBm/yaMnHMg3
	 /gIC1LnLYKEnq/YDW6+DjVhjJgaLUUi67EOTAE/cKo2xfdscDY5X+ss/3QSLobm5jFIuw
	 7O8ymDDLL404Mk7NNY/Hil6tzcv+068yoR2phbVDh6llXLTf9860Znm5eds+vHKAeD7gF
	 e062tvrQ7MZgNqBmGq/TAzH/8UvdKLcaCIB2/Lf6CWDfC0rbNb3QaRgIt23p21IpozJz7
	 dbZ8qOsJghlwpxgV9QZoFb7suedtlXFKac8QWRAO7JcjiG9ogSYgKYctLAnz3IeJ9Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghNYhmko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BA7606A337;
	Wed, 18 Nov 2026 21:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghNYhmko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5261F000CD;
	Wed, 18 Nov 2026 21:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795038509;
	bh=Hu4eabpEarZy5KdormXmkyULV0C3qWVe8T2guI6y3Y4=;
	h=Date:To:From:Subject;
	b=ghNYhmkohuG7Woc0uifb/Zqjrc/gSKymEqbNEbCPn82siOLU3gOGgJD+gbJBRFGHk
	 b57rjGI40ASYMgA3vMavjSjxOZlLSMxDnPEN6Q/4EouY0+Am2oXTuGUL4OXm2T4a3a
	 XGCn1VSnNJkX0XK7ZWE+u6uBmQaX+hS07mbiexps=
Date: Wed, 18 Nov 2026 13:48:28 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,
	chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,aquini@redhat.com,
	oleksandr@natalenko.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon.patch added to mm-hotfixes-unstable branch
Message-Id: <20261118214829.5F5261F000CD@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/swapfile: really fix integer overflow in swap_show() and swapon()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: mm/swapfile: really fix integer overflow in swap_show() and swapon()
Date: Wed, 18 Nov 2026 12:26:10 +0100

One of the enterprise customers uses 6 TiB of swap, and the values
reported in /proc/swaps as well as in dmesg are still not correct.

Cast si->pages to long explicitly so that the bitshift in K() doesn't
truncate the value to 32 bits.

Also do the same in swapon() for the same reason.

Link: https://lore.kernel.org/20261118112610.122799-1-oleksandr@natalenko.name
Fixes: 642929a2ded0 ("mm/swapfile: fix an integer overflow in swap_show()")
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: <stable@vger.kernel.org>

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon
+++ a/mm/swapfile.c
@@ -3452,7 +3452,7 @@ static int swap_show(struct seq_file *sw
 		return 0;
 	}
 
-	bytes = K(si->pages);
+	bytes = K((unsigned long)si->pages);
 	inuse = K(swap_usage_in_pages(si));
 
 	file = si->swap_file;
@@ -3968,8 +3968,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
-		K(si->pages), name->name, si->prio, nr_extents,
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+		K((unsigned long)si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(si->flags & SWP_DISCARDABLE) ? "D" : "",
_

Patches currently in -mm which might be from oleksandr@natalenko.name are

mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon.patch

