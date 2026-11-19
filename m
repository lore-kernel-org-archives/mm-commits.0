Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795113505;
	b=fx1GcBJsnuM17u2jdPmpWuRo5ZDeV96IOZH3A392BKlnm2wglVcil4RJ7wE4y3IX1tVn
	 QwiZF/QLNXPekyKqp9YmVRYdGzREHugHUrnhAOawLCB7Banv2I5sjYZASzaolwpRKLz9K
	 nWLYbPSHQBfcz+eETursVTrB0k97FpnAei4LUZ6qb/WIYSv15tJpMVqfs9YsZB6LWbXFA
	 NkDEf1fgwCbyF3JLH1KDg8OBrUU1hJPLnSLLJ2IpaxYpzMrpGa1iKsoHvuant1BXt+B4Z
	 x3FWUfOI+oSCpSls+FcM5t7dR95dCcp9LBhyb2GqR70mGtsji2kj3Hnz1Kk+iiRQIRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795113505;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=tYFas97y2rAXAV+ojut1DZS8F4xTaLUwyYcvley6SVM=;
	b=c5DSoXMvDceP5zcYziwRqZ0OuOGbGD/Zpsg3zuYUr46b4w2Ijv5QD8vcinR4e72ej12u
	 dFrbBcqJqUgcGnHkB+jG6u3PQ5LlIeMsCuVsOpfFMTsaUo6w36wYdK6AaR+YowrDjYas0
	 XS4wnZRfifbYg5dpX3jhBJ9wQrZc4p6AqlX4rH073WkeX3kv7K4xnK3y9lg3fBcQrLWje
	 Jz3buz053WMASPWlnWJAbouCrzE+iidbnlh7t7yc+8PnwwOh9oLMsqNrv99L0/XVOZkYa
	 YxdtkoXRIARR1p1m7mRKsDza3hdpulQe3Ox2toe1GGomxJbsH1xC2/2xbTiEbx+ZQQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LNqRK6nB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE836606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 18:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LNqRK6nB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833FA1F000C6;
	Thu, 19 Nov 2026 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795113504;
	bh=tYFas97y2rAXAV+ojut1DZS8F4xTaLUwyYcvley6SVM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=LNqRK6nB305cszezTrdulxoneO4QHJwiL7k5kx+Tu+hi8VCIyv4onoMifAbNB1FrI
	 f5HYwHspfNTLiPxudszlPS8T5Kx4JB5GjPiuO27ZTO0rQG2a7yfnqiMfI7O0JsLGC5
	 vPyXE+fXIpdBUAK0GNle2ZhyZzZLU2/UWRv8B284=
Date: Thu, 19 Nov 2026 10:38:24 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	elkin@google.com,david@kernel.org,irogers@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119170517.1515872-1-irogers@google.com>
References: <20261119170517.1515872-1-irogers@google.com>
Subject: + mm-backing-dev-pass-%s-format-string-to-device_create-in-bdi_register_va.patch added to mm-new branch
Message-Id: <20261119183824.833FA1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/backing-dev: pass "%s" format string to device_create() in bdi_register_va()
has been added to the -mm mm-new branch.  Its filename is
     mm-backing-dev-pass-%s-format-string-to-device_create-in-bdi_register_va.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-backing-dev-pass-%s-format-string-to-device_create-in-bdi_register_va.patch

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
From: Ian Rogers <irogers@google.com>
Subject: mm/backing-dev: pass "%s" format string to device_create() in bdi_register_va()
Date: Thu, 19 Nov 2026 09:05:17 -0800

bdi_register_va() formats (fmt, args) into bdi->dev_name via vsnprintf()
and then passes bdi->dev_name directly as the format string argument to
device_create(), causing vsnprintf() to run a second time on the already
formatted device name with no variadic arguments.  If a caller formats an
identifier containing '%', device_create() interprets it as format
specifiers and reads arbitrary stack slots.

Pass "%s", bdi->dev_name to device_create().

Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
-Wformat-security enabled; fix and changelog drafted with an AI coding
assistant.  Build-tested under LLVM=1 W=1 and -Wformat-security; not
runtime-tested with '%' in backing-device names.

Link: https://patch.msgid.link/20261119170517.1515872-1-irogers@google.com
Fixes: 6bd87eec23cb ("bdi: add a ->dev_name field to struct backing_dev_info")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Elkin Cruz <elkin@google.com>

 mm/backing-dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/backing-dev.c~mm-backing-dev-pass-%s-format-string-to-device_create-in-bdi_register_va
+++ a/mm/backing-dev.c
@@ -1097,7 +1097,8 @@ int bdi_register_va(struct backing_dev_i
 		return 0;
 
 	vsnprintf(bdi->dev_name, sizeof(bdi->dev_name), fmt, args);
-	dev = device_create(&bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
+	dev = device_create(&bdi_class, NULL, MKDEV(0, 0), bdi, "%s",
+			    bdi->dev_name);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
_

Patches currently in -mm which might be from irogers@google.com are

mm-backing-dev-pass-%s-format-string-to-device_create-in-bdi_register_va.patch

