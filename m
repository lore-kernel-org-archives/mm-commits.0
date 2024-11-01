Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF4C134BD
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730426207; cv=none; b=MARM5l8FjCv+/PyUqT1k1asnZxKTc3Lu8Xwc8ly0wmvEITOXxa27bWgccSSentN51scfSXCDiFJrSxFoDplqDrdOULa5iBf/tWf5K/98BBAmlr1Vll6YlsEr/w9284DqNhujq/kvgO1hXYpaK2RzjTpxLKPC/+J6c8S3CKtTIp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730426207; c=relaxed/simple;
	bh=KfgN+IlQmxywBFGxohSY3E6RS0EP7HvWFxXG+cY/uuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIc5pvyUGSJXRoS9hlp+/YsvQeHHBRlMPvQUjsbBJ4+0RIZ6yYAZaaHCc26ZTrLFfTjH/OkO8r8ocXB62zUibDrFMKczBUnY+QBrCI8iJQ0+paPaGS9xsReetmvUHq3mvgzONJIDHlifiKjyk2zCa/OxgOLLd5Ru7GoZ7aZkbog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NDLnJtf9; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NDLnJtf9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1730426190; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qiQTbhsgyLLivdmV9Am8QPxGagxVLy36xOaUIJP2vHU=;
	b=NDLnJtf9/MWH2ojKhtWCifV/agwDXETuszdAkJ2xuZGZgPIGa5NSK6iTFAeW/XA7TCxSwZ1+SCLTsYfT71/Ni+KaCSmrDvZs5dksqEf7Q7scxI00gLYPZuVpX+A/wieRuu8DRqGH+rMnTMCTe0tEMEvXNY0fIeMQNQzklvoBD9M=
Received: from 30.74.144.133(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WIKHsRr_1730426189 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 01 Nov 2024 09:56:30 +0800
Message-ID: <32dd938c-3531-49f7-93e4-b7ff21fec569@linux.alibaba.com>
Date: Fri, 1 Nov 2024 09:56:29 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch
 added to mm-unstable branch
To: David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org,
 wangkefeng.wang@huawei.com, shy828301@gmail.com, hughd@google.com,
 david@redhat.com
References: <20241026230305.32360C4CEC6@smtp.kernel.org>
 <44141.1730380578@warthog.procyon.org.uk>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <44141.1730380578@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/10/31 21:16, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> +		/*
>> +		 * Fallback to PAGE_SIZE splice if the large folio has hwpoisoned
>> +		 * pages.
>> +		 */
>> +		if (likely(!fallback_page_splice)) {
>> +			size = len;
>> +		} else {
>> +			size_t offset = *ppos & ~PAGE_MASK;
>> +
>> +			size = min_t(loff_t, PAGE_SIZE - offset, len);
>> +		}
> 
> It might look better to write this as:
> 
> 		size = len;
> 		if (unlikely(fallback_page_splice)) {
> 			size_t offset = *ppos & ~PAGE_MASK;
> 
> 			size = umin(size, PAGE_SIZE - offset);
> 		}

Yes, looks better. Thanks.

Andrew, could you help squash the following changes into this patch? Thanks.

diff --git a/mm/shmem.c b/mm/shmem.c
index 44282a296c33..d910063dac27 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3335,12 +3335,11 @@ static ssize_t shmem_file_splice_read(struct 
file *in, loff_t *ppos,
                  * Fallback to PAGE_SIZE splice if the large folio has 
hwpoisoned
                  * pages.
                  */
-               if (likely(!fallback_page_splice)) {
-                       size = len;
-               } else {
+               size = len;
+               if (unlikely(fallback_page_splice)) {
                         size_t offset = *ppos & ~PAGE_MASK;

-                       size = min_t(loff_t, PAGE_SIZE - offset, len);
+                       size = umin(size, PAGE_SIZE - offset);
                 }
                 part = min_t(loff_t, isize - *ppos, size);
