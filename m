Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD08156655
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212152; cv=none; b=DcrbMOexz6Ii5TSRoQtAhy1mUazY4uejfPesRQC++GrF2+Pzzl1XR8bv4I7OMiV+sTSEmeCI0Dikuhte6rU0vcvXqNpeoxTQNEOGs69Chv5oMRhc9LA3C4IjFtsoXV9t5j6CAoiOtWA058WWf4v8fbzruXhIx8oQy0iBgQwWZLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212152; c=relaxed/simple;
	bh=wN9gpCiXBRBBm1goL9JwdOyHDqcfap6V5pLyHQwIfnU=;
	h=Date:To:From:Subject:Message-Id; b=MBcHaZfwZgwBa2pS+tj8WcL7v4rdaQZ6LB8YyyKqYaxEepnu5DNYfitG0ErPyxEIETeDsb9PCIK8plKPeF1DProaLKZcaddSPw/+VdV7DSIyLhRi3YvDJMAOkCtiyCjsOnc76FfvHlak6KNwiYilYgdq1J3O2Bxym23yvtU4WAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tAstwW3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tAstwW3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D59BC113CC;
	Mon, 15 Apr 2024 20:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212152;
	bh=wN9gpCiXBRBBm1goL9JwdOyHDqcfap6V5pLyHQwIfnU=;
	h=Date:To:From:Subject:From;
	b=tAstwW3U4z3g0oyKTfFHYLjSgRkKhTV8S7gyAkqIReL9qRaiNac78MhOWa/4hGkbF
	 GdU6hW6SQ5xkaVloJsNiGhkVKmhKdj06RBpdp7mjcam3279vRhq3E8NTarFlbBPUf8
	 WVpaMW2ANnyZK2IxAvitb9gY5PhsprtXvPTfrQsI=
Date: Mon, 15 Apr 2024 13:15:51 -0700
To: mm-commits@vger.kernel.org,jikos@kernel.org,gregkh@linuxfoundation.org,bentiss@kernel.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240415201552.0D59BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: HID: sony: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: HID: sony: remove usage of the deprecated ida_simple_xx() API
Date: Sun, 14 Apr 2024 12:03:11 +0200

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Link: https://lkml.kernel.org/r/9b7684381f9d09a7cd5840caa2a160d7764d6403.1713088684.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-sony.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-sony.c~hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/drivers/hid/hid-sony.c
@@ -1844,8 +1844,7 @@ static int sony_set_device_id(struct son
 	 * All others are set to -1.
 	 */
 	if (sc->quirks & SIXAXIS_CONTROLLER) {
-		ret = ida_simple_get(&sony_device_id_allocator, 0, 0,
-					GFP_KERNEL);
+		ret = ida_alloc(&sony_device_id_allocator, GFP_KERNEL);
 		if (ret < 0) {
 			sc->device_id = -1;
 			return ret;
@@ -1861,7 +1860,7 @@ static int sony_set_device_id(struct son
 static void sony_release_device_id(struct sony_sc *sc)
 {
 	if (sc->device_id >= 0) {
-		ida_simple_remove(&sony_device_id_allocator, sc->device_id);
+		ida_free(&sony_device_id_allocator, sc->device_id);
 		sc->device_id = -1;
 	}
 }
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

