Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9812445DF7F
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757205; cv=none; b=Mb5PuU5/55OA6FF2xNK0APG8MWKJiWCsMjFC6OULXK7aLylxE7lwshaiTpmNcziGrBtvYQJh8dZZhMY0M8YjTpiFT/I9zUx5KX7eNjtn2hZ4hswd+UqUxvccJYdZYvTOcqgPcyy9GUZkmifOf+imjx+gYu3pp7dRcuZ4urvgzSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757205; c=relaxed/simple;
	bh=Np105DnKB6O68mFeBQfJJPehNBgy90dsevku/1gyZ5c=;
	h=Date:To:From:Subject:Message-Id; b=l0jquzJrEEYTY19XtrP4OOo+WmoZsjCLZgmXxhwEfARm5OChV2er8r/Q8AmnpTcbN4wp2t6cVLHpN8mO5h/Ao7DSamngIPISISE9nmWM5L0B39N7a1FjHIAYmQNHPKXzf5X1OAdMZL7/xJ8XuPDtBQqosvVn9b+pxbaH+Lm4k8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GQKRU9jJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GQKRU9jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E38C1F0089B;
	Sun, 11 Oct 2026 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757204;
	bh=9nafm2vuvJIV5pyeKPWYqMXXQ5ftokX3A/W7FfEbtmU=;
	h=Date:To:From:Subject;
	b=GQKRU9jJKuB4i1ap34LAQL5SoTojMtY22WwvgTAvDodRhxjz2OetGxGyFOTZYUzZd
	 6KlQdJ9SzLz2hEh4lNQHR0qP8QpTR8NhJdctzgh4Oq5zqQjLzhHhnxsIntx/Q4zEVP
	 9lT3LYlbnOzBFzKNkfCIMy0rJExNhNIyUEMvprPs=
Date: Sun, 11 Oct 2026 15:20:03 -0700
To: mm-commits@vger.kernel.org,jack@suse.cz,gregkh@linuxfoundation.org,matthias.goergens@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kdev_t-shift-in-dev_t-in-mkdev.patch removed from -mm tree
Message-Id: <20261011222004.5E38C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kdev_t: shift in dev_t in MKDEV()
has been removed from the -mm tree.  Its filename was
     kdev_t-shift-in-dev_t-in-mkdev.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthias Goergens <matthias.goergens@gmail.com>
Subject: kdev_t: shift in dev_t in MKDEV()
Date: Mon, 28 Sep 2026 06:49:58 +0800

MKDEV(ma, mi) evaluates ((ma) << MINORBITS) in whatever type the caller
passes, usually int.  For majors >= 2048 (legal: majors go up to 4095) the
result exceeds INT_MAX, which C11 leaves undefined for a signed left
shift; shifting a negative ma is undefined regardless of the major's
value.  In practice, on the compilers and two's complement targets the
kernel supports, both cases wrap to the intended bit pattern; this patch
makes the macro well defined regardless by casting the major to dev_t
before shifting.  For major and minor numbers in range, the device number
it produces is unchanged.

isofs feeds the Rock Ridge 'PN' entry's dev_high and dev_low into MKDEV()
while holding them in int variables (fs/isofs/rock.c), so a crafted image
can drive this exact shift.  Fixing the macro covers every caller instead
of just that one.

Link: https://lore.kernel.org/20260927224958.508964-1-matthias.goergens@gmail.com
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 include/linux/kdev_t.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kdev_t.h~kdev_t-shift-in-dev_t-in-mkdev
+++ a/include/linux/kdev_t.h
@@ -9,7 +9,7 @@
 
 #define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
-#define MKDEV(ma,mi)	(((ma) << MINORBITS) | (mi))
+#define MKDEV(ma, mi)	(((dev_t)(ma) << MINORBITS) | (mi))
 
 #define print_dev_t(buffer, dev)					\
 	sprintf((buffer), "%u:%u\n", MAJOR(dev), MINOR(dev))
_

Patches currently in -mm which might be from matthias.goergens@gmail.com are


