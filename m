From: akpm@linux-foundation.org
Subject: [patch 031/126] mm/hmm: fix build when HMM is disabled
Date: Fri, 08 Sep 2017 16:12:35 -0700
Message-ID: <20170908231235.ZtolQwp1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932716AbdIHXMh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jglisse@redhat.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm: fix build when HMM is disabled

Combinatorial Kconfig is painfull. Withi this patch all below combination
build.

1)

2)
CONFIG_HMM_MIRROR=y

3)
CONFIG_DEVICE_PRIVATE=y

4)
CONFIG_DEVICE_PUBLIC=y

5)
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PUBLIC=y

6)
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y

7)
CONFIG_DEVICE_PRIVATE=y
CONFIG_DEVICE_PUBLIC=y

8)
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_DEVICE_PUBLIC=y

Link: http://lkml.kernel.org/r/20170826002149.20919-1-jglisse@redhat.com
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-fix-build-when-hmm-is-disabled include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-fix-build-when-hmm-is-disabled
+++ a/include/linux/hmm.h
@@ -498,7 +498,7 @@ struct hmm_device {
 struct hmm_device *hmm_device_new(void *drvdata);
 void hmm_device_put(struct hmm_device *hmm_device);
 #endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
