Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FDA13AD06
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248795; cv=none; b=HrV8UbeJl+oh4rnPi3kMN4v54XnOoa/0ec8mI6k8PKniTWLHsvA0acQDQ8YNSDA/EbonNKN2tdIlRrK9+AwAVdFWUB5WABWr+yqNExLA6S5QmHxPyv/+PMJH48Sx6gDymT+8+/48BCPEkBJ7iBlbBPpOAw+IHZpMBS9RsOR+3Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248795; c=relaxed/simple;
	bh=tiKnF5iieZ6LtBh6kcAQ9htqRbMOmrssgojv4dA1h0Y=;
	h=Date:To:From:Subject:Message-Id; b=g6COSeu0S9ihLbnHL24PKjjOcdlHFHZeP5BHvVbCch0wP0VzG10zO7RQwkNEF69qQ0XNhkKwZVz/xZjArm1wI8ouf9WttAMmucsbBV+XYZE5ewpgwOgm3lBfX6/FtJqZ6/vU5Cfe4TueqrliSj/v+NgwXhlPtr1J4aHg5egzb7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BAAezB41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BAAezB41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F321C4CEC7;
	Mon,  2 Sep 2024 03:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248795;
	bh=tiKnF5iieZ6LtBh6kcAQ9htqRbMOmrssgojv4dA1h0Y=;
	h=Date:To:From:Subject:From;
	b=BAAezB41G9yF71Zsfa8PlMXVlwsUFZ1P/QXZlFTCNB+nydNfwrEnAV2BMTpGTeGan
	 rX5qvaUdcSl6+XBuRz+i7S9s+REIjDq9DI9JjxsmZvWnrqSxlJMBvDpdgq2O5Z85uk
	 vmrdhwIDBtcaaMzhooMZWSyTu8Jy7PXua/fUEq4E=
Date: Sun, 01 Sep 2024 20:46:34 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] failcmd-add-script-file-in-maintainers.patch removed from -mm tree
Message-Id: <20240902034635.3F321C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: failcmd: add script file in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     failcmd-add-script-file-in-maintainers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: failcmd: add script file in MAINTAINERS
Date: Tue, 30 Jul 2024 09:08:13 -0700

failcmd is one of the main interfaces to fault injection framework, but,
it is not listed under FAULT INJECTION SUPPORT entry in MAINTAINERS.  This
is unfortunate, since git-send-email doesn't find emails to send the
patches to, forcing the user to try to guess who maintains it.

Akinobu Mita seems to be actively maintaining it, so, let's add the file
under FAULT INJECTION SUPPORT section.

Link: https://lkml.kernel.org/r/20240730160814.1979876-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~failcmd-add-script-file-in-maintainers
+++ a/MAINTAINERS
@@ -8541,6 +8541,7 @@ M:	Akinobu Mita <akinobu.mita@gmail.com>
 S:	Supported
 F:	Documentation/fault-injection/
 F:	lib/fault-inject.c
+F:	tools/testing/fault-injection/
 
 FBTFT Framebuffer drivers
 L:	dri-devel@lists.freedesktop.org
_

Patches currently in -mm which might be from leitao@debian.org are


