Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2005B3603DB
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856537; cv=none; b=BXvtnfO16oRPggedgg5IaR+8btuqTKmUH9PYZazks/PJVgWstyFliF6FJy8SGCBduf5KaIfVeZsJEj7R196U3Asn/Tq/mzkXsWIvAMHSCCMGifP828Tw29gZEpkfYPk91gXOTUpTWpIdKALwV1xnuwi1Uk4RZE8Pk4UU3iGgDko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856537; c=relaxed/simple;
	bh=fJaG6Vp3aX8r1YSmcQ/Z4IIj93tOCBdrSqQhxnf3l8s=;
	h=Date:To:From:Subject:Message-Id; b=PTIhsS2dj5VlRgKO1fOUUfepNzeWmrzXJA3Skfv6KRuAyTSMLPQ9wcQNTJxkmR5yfG2ocjHW72EHvKbxLZoHln2PbpvZp+HcN+AwvAhHG6wgGCGvqLZ4JKesggABtlhsIVvxoVh51ceb6iKHLW1KpxIai6HZtidcvI+S19pLw/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCKThhmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCKThhmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8E3C19421;
	Wed, 18 Mar 2026 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773856536;
	bh=fJaG6Vp3aX8r1YSmcQ/Z4IIj93tOCBdrSqQhxnf3l8s=;
	h=Date:To:From:Subject:From;
	b=XCKThhmYhwDhniOuqr+YfbyD6mxlIv20tKJdOYsaV4keKGi0dqNDJ+tk3hieASkRf
	 oWEPdWgsoKXw6U+1OD+O1i8x7ZQ0UydvTKUJHKpyy1J7d4ctfdgP95+zF5Z3YLaDVc
	 a/iDRcPrD7fn1L3HEhKB6WMn8vhATrPITmkPi+xQ=
Date: Wed, 18 Mar 2026 10:55:35 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,derkling@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decodecode-return-0-on-success.patch added to mm-nonmm-unstable branch
Message-Id: <20260318175536.5F8E3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decodecode: return 0 on success
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decodecode-return-0-on-success.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decodecode-return-0-on-success.patch

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
From: Patrick Bellasi <derkling@google.com>
Subject: scripts/decodecode: return 0 on success
Date: Wed, 18 Mar 2026 15:05:45 +0000

The decodecode script always returns an exit code of 1, regardless of
whether the operation was successful or not.  This is because the
"cleanup" function, which is registered to run on any script exit via
"trap cleanup EXIT", contains an unconditional "exit 1".

Remove the "exit 1" from the "cleanup" function so that it only performs
the necessary file cleanup without forcing a non-zero exit status.

Do that to ensure successful script executions now exit with code 0. 
Exits due to errors are all handled by the "die()" function and will still
correctly exit with code 1.

Link: https://lkml.kernel.org/r/20260318150545.2809311-1-derkling@google.com
Signed-off-by: Patrick Bellasi <derkling@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/decodecode~scripts-decodecode-return-0-on-success
+++ a/scripts/decodecode
@@ -12,7 +12,6 @@ faultlinenum=1
 
 cleanup() {
 	rm -f $T $T.s $T.o $T.oo $T.aa $T.dis
-	exit 1
 }
 
 die() {
@@ -49,7 +48,7 @@ done
 
 if [ -z "$code" ]; then
 	rm $T
-	exit
+	die "Code line not found"
 fi
 
 echo $code
_

Patches currently in -mm which might be from derkling@google.com are

scripts-decodecode-return-0-on-success.patch

