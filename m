Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795742366;
	b=NUJOYwbNn3veQNxJ9KPIKoSLks6sHe4Z0sfifGzTV6YshSXHkG5lIYSExYWwXUVqlK+p
	 HukWIc5eM2gK9+Jv9B/nhAaV5S0bMVzBXpqAN5OguVD+GobX9gXsSYuJnSmuqmvmMouE5
	 61qrHR5HSPhWBPJZaVTh2dtthlF4OMRolk5Ig4XXi9SFPKhl603UeFoy+tNsOSUH3LDLg
	 JE1vcgUmxmwb5khummWMTr88Jp6yOCGQFhMScu1IEvPACp68jToKoEg6zH2O1Vsk9uNjl
	 AVW705w5yblL7oq9NQzouCT8Cora8tJXT1TuCuSYDnIHkRPZms7Qw7hkw9TJTJX8Wlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795742366;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=64flVjBDnrU72YvR+G7I9IfTlEVBHZROISseGqmoflk=;
	b=rUnS63YWw9foo4TUUCNUhJizYLnziyLXcZX7wPRvrzWTh8mSiqfobVnSKgFdL/kvlIHv
	 7Lon8Cqe8MFmLcu6zJHCV2m8iTQdfIzsfqbQWeZjnnRyvQsG7WUvfT+fwZiW4HyJhYrpm
	 cqNhizwvtHB3pSkMsGruCkCiaSyyzhg6a+ZbWfuQio/FWNk3cotu9CNG6o8QkZ0o3gpW+
	 7i90UWxhFIjwCViSloHzk1gYFDa7+iKkqPlRUFtIgmjGXgeKOC4R1aVE6tpbC1SPZZpIV
	 tJjVmcBvpCihbO4KMgX16+j6Tt/8wHiVn5jL2zbZnZmch2CEPm0es3sfVoZv16dsICA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qDNfSCUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45183606A324
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 01:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qDNfSCUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C651F000C1;
	Fri, 27 Nov 2026 01:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795742365;
	bh=64flVjBDnrU72YvR+G7I9IfTlEVBHZROISseGqmoflk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=qDNfSCUZwAJpSzZ2N4r6vX5QazInEP1ag86zcZuQ/I5r000g0eYN53/uOfIphCxnE
	 NatbRf6wjSdq41VOtH0ewz6EESYmjpt5jqiXW5Y3G6tSwFvN06DM4yCpMWhVNMGxZH
	 4uSl1VDLZXJ5e7CLBJiudW3enho9rUBFgOKuF6tM=
Date: Thu, 26 Nov 2026 17:19:25 -0800
To: mm-commits@vger.kernel.org,ynorov@nvidia.com,vkoskiv@gmail.com,
	edumazet@kernel.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261126-bloat-o-meter-help-v1-1-fb0785c94bbf@igalia.com>
References: <20261126-bloat-o-meter-help-v1-1-fb0785c94bbf@igalia.com>
Subject: + scripts-bloat-o-meter-describe-output-fields-in-help-text.patch added to mm-nonmm-unstable branch
Message-Id: <20261127011925.C1C651F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: scripts/bloat-o-meter: describe output fields in help text
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-describe-output-fields-in-help-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-describe-output-fields-in-help-text.patch

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
From: Mauricio Faria de Oliveira <mfo@igalia.com>
Subject: scripts/bloat-o-meter: describe output fields in help text
Date: Thu, 26 Nov 2026 19:13:00 -0300

First time users of the bloat-o-meter script might not understand what
its output fields mean (add/remove, grow/shrink, up/down, Before/After),
and even occasional users might eventually forget.

Describe the output fields in the help text, so it is quick to find out.

RawTextHelpFormatter is used in order to keep line breaks in place.

Link: https://patch.msgid.link/20261126-bloat-o-meter-help-v1-1-fb0785c94bbf@igalia.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Valtteri Koskivuori <vkoskiv@gmail.com>
Cc: Eric Dumazet <edumazet@kernel.org>

 scripts/bloat-o-meter |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-describe-output-fields-in-help-text
+++ a/scripts/bloat-o-meter
@@ -9,10 +9,32 @@
 
 import sys, os, re, argparse
 from signal import signal, SIGPIPE, SIG_DFL
+from argparse import RawTextHelpFormatter
 
 signal(SIGPIPE, SIG_DFL)
 
-parser = argparse.ArgumentParser(description="Simple script used to compare the symbol sizes of 2 object files")
+description = \
+"""
+Simple script used to compare the symbol sizes of 2 object files
+
+fields:
+  add/remove:   number of symbols added in the new file / removed from the old file.
+  grow/shrink:  number of symbols in both files that had a size increase / decrease.
+  up/down:      size of symbols added plus size increase / removed plus size decrease.
+  (change):     difference between up and down sizes.
+
+  Symbol lines: symbol name, old size, new size, and size delta;
+                '-' means symbol added/removed;
+                '0' delta symbols not included.
+
+  Before:       size of all symbols in old file.
+  After:        size of all symbols in new file.
+  chg:          percent change.
+
+  Symbols in both files with the same size are only counted in Before/After/chg.
+"""
+
+parser = argparse.ArgumentParser(description=description, formatter_class=RawTextHelpFormatter)
 group = parser.add_mutually_exclusive_group()
 group.add_argument('-c', help='categorize output based on symbol type', action='store_true')
 group.add_argument('-d', help='Show delta of Data Section', action='store_true')
_

Patches currently in -mm which might be from mfo@igalia.com are

scripts-bloat-o-meter-describe-output-fields-in-help-text.patch

