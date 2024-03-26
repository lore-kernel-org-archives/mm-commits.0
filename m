Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579B74CE09;
	Tue, 26 Mar 2024 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476499; cv=none; b=Yw5CW4IzYMfaTwAksXavqg/PgqjzbVn3zpP0pivl7BIpjuMGgDipRyS1CkQOTYNOH8xSQ2e8dgmwSS7Fa7DQrzPvp+09JU7B7JqwxiGKhL86hGRZDhi5CD5tuOttsxprdcEqxsPozFFS2wskHlo/W1qI7I5habSzPq0id10cyQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476499; c=relaxed/simple;
	bh=Khhh1ZLvxT6fxllkqRRqmsp4cXTsqy6SAp6jE45FhEU=;
	h=Date:To:From:Subject:Message-Id; b=hl1AOaB253mirXEN71xCwc7ofxY8rjP1DnfGEL/W10bt1oWg/endeVRiVITHP6616kDiSnPXFx6Up/N2C1E7IFzLkuxMqf60MmWnVzWyfmLfRO+v8zmhswUSciGZDbpNrt4qP2GKbqfaan6XIUjxvoTlPg4YyIp5QCL1/miEpVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XNHsk4Qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XNHsk4Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F5FC433C7;
	Tue, 26 Mar 2024 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476499;
	bh=Khhh1ZLvxT6fxllkqRRqmsp4cXTsqy6SAp6jE45FhEU=;
	h=Date:To:From:Subject:From;
	b=XNHsk4QfOqckhK4aZX2uj6guDaS7s4ptdPICu0kHJeUCEihRboL1FGke1UZ6CsWxL
	 zUTVFhXH5+bWyC5Z//0PZnCuJILd4fKkHI4gZe702lFQ0UfnWoIu6ZpbuKtKj+mcT3
	 XvIkyT3OyEvVlKsYz+IyZRJNl+Qf893FxNBdshBY=
Date: Tue, 26 Mar 2024 11:08:18 -0700
To: mm-commits@vger.kernel.org,msakai@redhat.com,jserv@ccns.ncku.edu.tw,dm-devel@lists.linux.dev,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev.patch removed from -mm tree
Message-Id: <20240326180819.29F5FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove incorrect M: tag for dm-devel@lists.linux.dev
has been removed from the -mm tree.  Its filename was
     maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: MAINTAINERS: remove incorrect M: tag for dm-devel@lists.linux.dev
Date: Wed, 20 Mar 2024 02:18:42 +0800

The dm-devel@lists.linux.dev mailing list should only be listed under the
L: (List) tag in the MAINTAINERS file.  However, it was incorrectly listed
under both L: and M: (Maintainers) tags, which is not accurate.  Remove
the M: tag for dm-devel@lists.linux.dev in the MAINTAINERS file to reflect
the correct categorization.

Link: https://lkml.kernel.org/r/20240319181842.249547-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev
+++ a/MAINTAINERS
@@ -6173,7 +6173,6 @@ F:	include/uapi/linux/dm-*.h
 
 DEVICE-MAPPER VDO TARGET
 M:	Matthew Sakai <msakai@redhat.com>
-M:	dm-devel@lists.linux.dev
 L:	dm-devel@lists.linux.dev
 S:	Maintained
 F:	Documentation/admin-guide/device-mapper/vdo*.rst
_

Patches currently in -mm which might be from visitorckw@gmail.com are


