Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FC5136E0A
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293599; cv=none; b=rf23/Ae00dsne3DaAg0Qf9KrgMqbd27jXW8tTu/pwBBmnScA0T+rG6EWlEVqYKz5Jp7boUwmP0t2PDyJFz1UW/FEmCMyRk/axwLgjZH4+6oV+8G+FIx4lfGNSW2xWzf5Zq9vPBxTuik84sKr06G+NUAg/wvvswq8BDmB3uaFNkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293599; c=relaxed/simple;
	bh=IIjfXBRz1wVYDf4tCGQ2Gmp8AxlSbA2X/yo6UcPiRpM=;
	h=Date:To:From:Subject:Message-Id; b=tyURs+ZhQZExD60tAhdai5fz81vbU2Ab8qVUHkdOg7vfuxCzwhCKCk7QMQDslq+a+9IfYEZbaAxFWyhrRO/L3TvvuqrlNMafJUpm0Rrb/VZTqu0u2qreRmIxV9or/hwboYilph3fqgUeLkFnPBguLj5tBrfWX8sdJdRVjtGSTcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2pCR+pHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2pCR+pHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1AFC113CE;
	Tue, 16 Apr 2024 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713293598;
	bh=IIjfXBRz1wVYDf4tCGQ2Gmp8AxlSbA2X/yo6UcPiRpM=;
	h=Date:To:From:Subject:From;
	b=2pCR+pHEH2IX4Es/UKnv3Qu2eAk3L/sDl+zZvQ8yu6gwCJbT8owqIGvQYatsDTHzB
	 I4COnlgs7/53P1ZcWnPYB2DIPsOnhrXFC07UPfsjBgXTIhXdJYD6FTHLIXiWwTF7DZ
	 hdFQQmtE7+BWT2UezO4a4tb1rrLbKfheOYWBYbwU=
Date: Tue, 16 Apr 2024 11:53:18 -0700
To: mm-commits@vger.kernel.org,jikos@kernel.org,gregkh@linuxfoundation.org,bentiss@kernel.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch removed from -mm tree
Message-Id: <20240416185318.8E1AFC113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: HID: sony: remove usage of the deprecated ida_simple_xx() API
has been removed from the -mm tree.  Its filename was
     hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

