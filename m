Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D171A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161339; cv=none; b=iH8mnffdEHQypGIwdLzi6dUDT3gNELolL7Q4jts88K1SOIFPe8Tqsigt+haxW8KZsKxeRflNt3/fIHY6/cMtGq64Cb+kOwQH17a8ZCJecVwu90Epq+ApLCwxqUqkgE7g88lDF+purb579gz2kxgWcrFhU7pQdVSyyGkZDpHT74E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161339; c=relaxed/simple;
	bh=jPOvLpbSzEa46bAK6PSBP8ETzZPWKn6IHeFMRDuuBCI=;
	h=Date:To:From:Subject:Message-Id; b=sGmxvOcd5GDWkxuomGYxpuvq7yI029o8XUvT6HbpexE/JnAeiQ2F8NppQxKM7KerCjUMCAToZJCU4Z7mTPVgfSgSjtad+xAYye8WjumAfeBUm7pnCL4JAaUUk0cbrNWhRdcjf0pGE5DA7ilxfNNlPFqdp+wpF514WW3GJBxfvcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1AHVu/65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1AHVu/65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E810C4CEEF;
	Sat,  2 Aug 2025 19:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161339;
	bh=jPOvLpbSzEa46bAK6PSBP8ETzZPWKn6IHeFMRDuuBCI=;
	h=Date:To:From:Subject:From;
	b=1AHVu/65EDMpqbmshbscoGZPDKrQaBy/NT4OGtu4U222JKK0vQg2j31BPSVH3jpo+
	 kJ0bGNrJU/vjPxAHCAo1xj3Giu+qqcMvkV6gpBjbklVT/PIhN1rtZGhwue6GpeYKLs
	 bnqKrFURZAqeSZUKqa09dK8mEFnvvedlc7ley5qo=
Date: Sat, 02 Aug 2025 12:02:18 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,paulmck@kernel.org,mengensun@tencent.com,mark.rutland@arm.com,linux@weissschuh.net,legion@kernel.org,ebiederm@xmission.com,bigeasy@linutronix.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ucount-fix-atomic_long_inc_below-argument-type.patch removed from -mm tree
Message-Id: <20250802190219.4E810C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucount: fix atomic_long_inc_below() argument type
has been removed from the -mm tree.  Its filename was
     ucount-fix-atomic_long_inc_below-argument-type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: ucount: fix atomic_long_inc_below() argument type
Date: Mon, 21 Jul 2025 19:45:57 +0200

The type of u argument of atomic_long_inc_below() should be long to avoid
unwanted truncation to int.

The patch fixes the wrong argument type of an internal function to
prevent unwanted argument truncation.  It fixes an internal locking
primitive; it should not have any direct effect on userspace.

Mark said

: AFAICT there's no problem in practice because atomic_long_inc_below()
: is only used by inc_ucount(), and it looks like the value is
: constrained between 0 and INT_MAX.
: 
: In inc_ucount() the limit value is taken from
: user_namespace::ucount_max[], and AFAICT that's only written by
: sysctls, to the table setup by setup_userns_sysctls(), where
: UCOUNT_ENTRY() limits the value between 0 and INT_MAX.
: 
: This is certainly a cleanup, but there might be no functional issue in
: practice as above.

Link: https://lkml.kernel.org/r/20250721174610.28361-1-ubizjak@gmail.com
Fixes: f9c82a4ea89c ("Increase size of ucounts to atomic_long_t")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: MengEn Sun <mengensun@tencent.com>
Cc: "Thomas Weißschuh" <linux@weissschuh.net>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/ucount.c~ucount-fix-atomic_long_inc_below-argument-type
+++ a/kernel/ucount.c
@@ -199,7 +199,7 @@ void put_ucounts(struct ucounts *ucounts
 	}
 }
 
-static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
+static inline bool atomic_long_inc_below(atomic_long_t *v, long u)
 {
 	long c, old;
 	c = atomic_long_read(v);
_

Patches currently in -mm which might be from ubizjak@gmail.com are


