Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ECB10A1B
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 05:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709615958; cv=none; b=mo80jTNfMOpyOLl67VzszFqjJ8D1L0OqI5fZ1SIGAw/Wnt8xM/NdTBdGAMjD8VWcKZtZ5fwiuJfreI0JE3IFX5KvpdkTdNxDr8bM9ABpE1JY6Gu4yp3JQY1VWN8ImixuKFG3fOMpiMd1oB9LfZtgg2aMnyue32qQWPRiBv3Tpyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709615958; c=relaxed/simple;
	bh=Rjj5ou1XAzQApdPHsLFoi3aL5J1+quxDA4UBkxYZd1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0fuC7/s3CoHy9oyzh5p0QH0HRfd4+oZI+UPReRsPXEseVVbL6uj6A/cohXfOiU961vFB33zYUAtGChvtX7Q1CjcVRMtM6QFgRMFtzEDpqjskv82sByXU6+gbpVAZSfMRkSqnSH+V3Ga9HadPCOTDeoKZezBcDCFN4GWedlzvEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c9hDAuQl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c9hDAuQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709615955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wuCkWdtz79lvqpSghMVmbUJfNWo+CSQ88jjSNKw/Vnw=;
	b=c9hDAuQlmiNRi+qHGLkVV7AYnRIZoLNQq+Qu1ITX2V2zQot+uJyT5CU624kafyI6x46mXR
	/ripWwcaL4yBAKmYJXmJgDLT+7Fl5nUC8h0+FVQr+T7jRaJz723BmqCYeHRO6pz6IB7Prx
	oKV6yIVcY2a6qg2fZdy7sy2kSETRO5A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-ur0yTltnMgq8SDcQWE1gYA-1; Tue, 05 Mar 2024 00:19:12 -0500
X-MC-Unique: ur0yTltnMgq8SDcQWE1gYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8D0484B0C5;
	Tue,  5 Mar 2024 05:19:11 +0000 (UTC)
Received: from localhost (unknown [10.72.116.6])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07E14202451F;
	Tue,  5 Mar 2024 05:19:10 +0000 (UTC)
Date: Tue, 5 Mar 2024 13:19:07 +0800
From: "bhe@redhat.com" <bhe@redhat.com>
To: =?utf-8?B?5byg5rSL?= <yang.zhang@hexintek.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiArIGtleGVjLWNvcHkt?=
 =?utf-8?Q?only-happens-before-uchunk-goes-to-zero=2Epatc?= =?utf-8?Q?h?=
 added to mm-nonmm-unstable branch
Message-ID: <ZearS74XGZAspiCA@MiWiFi-R3L-srv>
References: <20240301174340.642BEC433C7@smtp.kernel.org>
 <d5dcc228289d48109a558d8fafdc3590@hexintek.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5dcc228289d48109a558d8fafdc3590@hexintek.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On 03/05/24 at 02:25am, 张洋 wrote:
> Thank you for your reply
> 
> I am not very clear about the next process. I would like to know if there is anything I need to do next. I hope you will not hesitate to give me your advice.
> Thanks again.

No, you don't need to do anything. Andrew has been helping pick 
kexec/kdump patches into his tree, then will submit them to linus's tree
during next merging window if code is reliable.

