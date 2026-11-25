Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590766;
	b=yni75ayIDcSOZ4wY1gFL87cdUrTsxsZneZdy2Yw0Lta8ivGQVCrrp11YU0FcSunaAvPm
	 vn8uYgx/SjKjk5JkF58HhlBLupQdyptvCfSDVrT68KCANXUmEaF/zEf1w4LASqRw6KC+i
	 RNEaEppL0sVXaETCdODOso9m+AfosZbywb46wxmcY2aoiDNYJ8Xea8d0QCFVl9wbaMwn9
	 v2wMF5cWGlprTr3qXne1gf1jCMDvOdf2YUiN0hZ7QwlipZt9cvnVA0659cifErAooNorW
	 bmxgOJJEkC7RUkG7M0sdrYPzFAQGvXoZcIgZI1b0mNxvzmJMS1k+dSCyotCRvo89Iow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590766;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ET7byhTGWdoCAkrrW08JXQRENjk5HQXxt+KlxCm0vOc=;
	b=tr7qyrSF9ToS9CvV+BtEdU7LkNrh5EFoLTXxoYVAl38W9n9wOvtE4LfFsmuQ+hdr5VSp
	 tOlKOoyh95e4/PUyu+83t/vBfw/j2u3vHtuOdGBiumbDma7WEzqHkOJk2PIxpmAthNCAQ
	 ordZx0HwR7JKc1h7RZVXFPcyuachzD2Ugs1sU1IEWrDduJ0zNppU/RO+G3l4zProMDDcl
	 E8vgxRN8KuznHP92IQWu3CIyXpHebk/LMCehQcRSlAK52E59X7r0kXBbdRkr4JQMhmTzc
	 e2LeFUtUIxiKoH5x7wj37CxlOW9hhGFiWI2vMSFV8bPfMtYgGwY/JaZLZY1uXm9SLSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zgyI0MEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453E8606A680
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 07:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zgyI0MEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4982F1F000C4;
	Wed, 25 Nov 2026 07:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795590765;
	bh=ET7byhTGWdoCAkrrW08JXQRENjk5HQXxt+KlxCm0vOc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=zgyI0MExv3MjSQz9TmNiJ5bWaE9DEX8uJDzMgZRw6KbvgzHg+2M02A2osjK3D+Dib
	 AOOlPqeloAHbzPsPK0CFCDQAdhiocHepISlRoyvUBIa+748f15Et0cBtI9h5g2ssCR
	 TvHitPmSLIjun/m8uAb8zfArMRyqhE2xm/IddzGg=
Date: Tue, 24 Nov 2026 23:12:44 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ts930@dgu.ac.kr,
	surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,
	david@kernel.org,alx@kernel.org,azpijr@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261102074412.189554-2-azpijr@gmail.com>
References: <20261102074412.189554-2-azpijr@gmail.com>
Subject: + mm-mlock-make-a-zero-length-request-a-no-op-whatever-the-alignment.patch added to mm-new branch
Message-Id: <20261125071245.4982F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mlock: make a zero length request a no-op whatever the alignment
has been added to the -mm mm-new branch.  Its filename is
     mm-mlock-make-a-zero-length-request-a-no-op-whatever-the-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-make-a-zero-length-request-a-no-op-whatever-the-alignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: mm/mlock: make a zero length request a no-op whatever the alignment
Date: Mon, 02 Nov 2026 08:43:59 +0100

Patch series "mm/mlock: make zero length requests a no-op and reject
wrapping ranges".

Follow-up to Park Tae-sun's patch [1], which was dropped.  David asked
which of the cases it raised can actually be triggered, and for selftests
that show them.  Two can.

Patch 1 makes a zero length mlock()/munlock() a no-op before the address
is rounded. Today mlock(addr + 5, 0) locks a page and munlock(addr + 5, 0)
unlocks one.

Patch 2 rejects ranges where start + len overflows, or where the end
overflows when rounded to a page. Today these get a silent success, act
on a single page, or get -ENOMEM/-EINVAL depending on CAP_IPC_LOCK.

Patch 3 adds both cases to mlock2-tests.

I could not find the commit that introduced either behaviour in the git
history.  Both are already present in the earliest history I could find,
so they may predate the imported git history.  There is therefore no
commit to use for a Fixes tag.  I have not added Cc: stable since these
changes intentionally alter UAPI-visible behaviour.

The mlock-random-test failure CI reported on [1] came from that patch, not
the test: it assigned 0 to do_mlock()'s error, which has to stay -ENOMEM
for the over-limit case, so mlock() over RLIMIT_MEMLOCK without
CAP_IPC_LOCK returned 0 without locking anything.  With [1] applied the
test fails 40 runs out of 40; with error set back to -ENOMEM after the
check_mlock_range() call it passes all 40, as it does with this series.

Tested on x86_64 (KASAN, lockdep) in QEMU: mlock2-tests 31/31 as root and
as nobody, 24/31 and 23/31 on mm-unstable; mlock-random-test and
on-fault-limit pass.


This patch (of 3):

A zero length mlock() or munlock() at an unaligned address is rounded up
to a page, so mlock(addr + 5, 0) locks a page that was never asked for,
and munlock(addr + 5, 0) unlocks one the caller may still rely on.  An
aligned zero length is already a no-op.

Return early for a zero length, before the rounding and before
can_do_mlock().  This is a uapi change: with RLIMIT_MEMLOCK=0 and no
CAP_IPC_LOCK, mlock(addr, 0) returns 0 instead of -EPERM, which is what
munlock(addr, 0) already returns.  man 2 mlock does not say what a zero
length should do, and -EINVAL would break callers that pass one today and
get 0.

Link: https://lore.kernel.org/20261102074412.189554-1-azpijr@gmail.com
Link: https://patch.msgid.link/20261102074412.189554-2-azpijr@gmail.com
Link: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/ [1]
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Closes: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alejandro Colomar <alx@kernel.org>

 mm/mlock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/mlock.c~mm-mlock-make-a-zero-length-request-a-no-op-whatever-the-alignment
+++ a/mm/mlock.c
@@ -612,6 +612,9 @@ static __must_check int do_mlock(unsigne
 
 	start = untagged_addr(start);
 
+	if (!len)
+		return 0;
+
 	if (!can_do_mlock())
 		return -EPERM;
 
@@ -678,6 +681,9 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 
 	start = untagged_addr(start);
 
+	if (!len)
+		return 0;
+
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
_

Patches currently in -mm which might be from azpijr@gmail.com are

mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch
selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch
documentation-userfaultfd-document-rwp-behavior-when-the-pte-is-dropped.patch
mm-mlock-make-a-zero-length-request-a-no-op-whatever-the-alignment.patch
mm-mlock-reject-ranges-that-cannot-be-represented.patch
selftests-mm-test-mlock-and-munlock-range-normalisation.patch

