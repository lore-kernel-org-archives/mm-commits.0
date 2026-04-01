Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6503BC693
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 09:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775034659; cv=pass; b=noRc2vRIYl08o+yZuGzKvVd6bWMyBlrV5eURiMRAOs0PygrASBMTtwVKFLKX6H4pZSTZj3rVSmnenIYE0/7i2Oa9t7soaCfGgyUrxTobQJcpIHpk0goyAFM7g03C7XDdwNiAaXhKG/R57/rBZRGDcr4+npriCD9auaCyTKOzKKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775034659; c=relaxed/simple;
	bh=BpWbwXX4sckBEai18gASMAS6RM+OZyNNnIe1AiKcxUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BKLUTQrXvw1cqPr0j7HQhKR0WjddJq6+cjIGQkNG2hSW41tNZQg+6KpETtNopbwsIIGV9h7HKPTBHvNk7S2TYJ2gHI+x+9uIypcGyMd9/vMLcW70rLMSbBB1JAMipUrHeRVk/vPGwhe/JDuKLxjDo8DqqlJe9pSxx/SJNOMyLtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Po487pFQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFhkF0yg; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Po487pFQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFhkF0yg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775034657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1yqyHHXEf8r7v1NukvriEHfPGJM3/0wqwmihHxXtbWc=;
	b=Po487pFQsJYLOdEF8aoaH6ENsN0I/eNWueBk3DUH9VSssCLAn72CPjKMeBsOtOCpPPmW26
	4nkBbfgHvT5/UdkKNY0//tTWkjcWhRxI0Ca2f8J3vdLelWx9COVEcxTQof90s38dgddKXf
	gfCPqZudbdsm0kXLtkuGlnLJsvgVLt0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-vtvVunpBPbGDVI-_krNXzw-1; Wed, 01 Apr 2026 05:10:55 -0400
X-MC-Unique: vtvVunpBPbGDVI-_krNXzw-1
X-Mimecast-MFC-AGG-ID: vtvVunpBPbGDVI-_krNXzw_1775034655
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b983ca42edfso60409066b.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Apr 2026 02:10:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775034654; cv=none;
        d=google.com; s=arc-20240605;
        b=Bm9ag8ZYbCtsXKzHflBEbzct/Iseo7yI+wX4PgUwH18VXIXzrzNiYRO8DS2TGmsfSk
         tBZQJ2QcVi3Zty6VmgT8HqO8r3a4GOtic+7M2XOTQBKGPtCI0dh22YgrHJxO7NBNMPFb
         HybgHjYukARhCCJPLk3VCdcKCMXtaupL/qOs0Y/Bsb52MSPSsCXzw87dUirw8Sabi6U1
         HTeBp6+9ZoOqzWKSUQ8Hl99pT+g3BPD8ab3x//X+GrYYvZ8JSpMW/+THYESDeGW9tn59
         Mzkq2sNePUKzamXLivrInUi0JiyXkP94g5CLWAG8Mrji0EV+fspET7KuJWWjY4QS2iPy
         0W5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1yqyHHXEf8r7v1NukvriEHfPGJM3/0wqwmihHxXtbWc=;
        fh=GmRyhpI34t+5rvg0NZed2mQGfYUXt2yBTBHkslE3mX4=;
        b=LG5c32Bgo32nuaXr/eNJ7rCZjvCkWZ0WD8TEt18w3vxLaiF7LaD71YHeCzRviNZ1Jb
         NPfLTeVJMGVV8CogwAFrjlm/A/qlC4xu2NmJIdujGqQq42ZYvGGu+vLXGs24oZpALhTu
         5tiMAA1lUFuvbLVu1hCsB5hENuNob8R7yccExeIz7NJ8XyC5nUDcIr+kV2piSlyCKhVU
         RG29Y4vJ/IQhRGIzYhkWR8227bKROvq//ZOLJ7ejhgu0DUM+TF9xBdvHHL+EjsuiTMEv
         1ZJSfu2qwUprTW7GL61xKPM17tOv3oVfVDOSvBgtkV9ekgQoqExl/YxRSCDwt/4EpRrR
         ulcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775034654; x=1775639454; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1yqyHHXEf8r7v1NukvriEHfPGJM3/0wqwmihHxXtbWc=;
        b=QFhkF0ygtLNC+IsM9ULTozZDWU3w3gkc3CsCsexU9nOF1pAFAodBmk2HEubZazFN89
         ZfRy3GRcBO7gnx31mHtGmtovsD3u9HzJAGR68xc4SIHUWN9431alzlqHNYdncMTQDklq
         q66Puk4xqDLRli/cr9lt9GGHY2fUhdZPm+Xin5o6Gbw8ax9Aw8M1+53AlzJT2FnjWF/3
         /WgoM1OlIPc9xXx8/GYeDDtexzPgcZPntij7OYyoVOLSFWtxOyUwr2WOsb6RzuvY+WX2
         qSCIB/1w/ovhl77vrtCxhDZuYababDzs0I2BX2QJTEEFSQhm8hvsGmQDM1vPvByNzAc3
         qTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775034654; x=1775639454;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1yqyHHXEf8r7v1NukvriEHfPGJM3/0wqwmihHxXtbWc=;
        b=cd5iPfFqqPiITGy0h3fXvIpfYyc+vzSvO4uTzxN0wps2VzbXXN1LjdUcyn2Vq2CLAY
         OdPFmy/FIjnNjU8kilibT37VXXHAhGx/tm0qvsr9vljhlICPVZpJ+WowOOnHG2O+l5cv
         dHnmX678G5YtwmF1o/qWuTQSaHMNFy0WzEq7RM1BTSYGxhoOu4tOvTA2xZdeYl9PKHJG
         wgpTzcdwbaSiEOXlqfoSX7vu0u8bFxt4Mu6kgWKrXSjYRIjERsxF3Me4k9DuD/Nov+ZJ
         Zdc/YOLQw9sHkO84m76XLbtWbCf/miNdgXaqQxeZ254wxhhbaApUAopCJMFO3upKmtud
         O82A==
X-Gm-Message-State: AOJu0YzwYHxL0aA+GCmI+1waec6d6AXkinO4RdBsNJOrhUgD8UnzFMiB
	61amAcr+WyZae2Yqo0SjqkjHw8CtqlxeFX1VjuX3W/1dJ9voAl78hhTOkT2lexxbF05P8Y1CkX/
	tIlGOIEF9MfMV30dmVlWvHqz43xJFJzpfPr2AdUKYTgRnVreQTBl7W1EIh2mMH1+9R8Xzuslbqh
	R9f6jpKULK6ri/u7gpH21wGqTAKkJ6qBCOHsGewg==
X-Gm-Gg: ATEYQzyDCN2VthYa75NbBS3Z07ALtwjLfxaydRHob4My9xYIiXFR0Itk3Vi4DBKqIyx
	8AIv2VkPFz4tWzESkxSwzYOJaHkC5NAugp+ngyyWO089RKWE4rmFsKqqd6CXKaWHxICMpIrucmL
	FzA9gWZ+BgsZoSUbKO6CMOzzkSIPEM2JcmsLu74syIR0/SXbmnhfSr6+wM57wbTLbP0HemL/e1X
	xR1fS0=
X-Received: by 2002:a17:907:9625:b0:b9b:5fee:4d51 with SMTP id a640c23a62f3a-b9c157159f5mr151976166b.10.1775034654280;
        Wed, 01 Apr 2026 02:10:54 -0700 (PDT)
X-Received: by 2002:a17:907:9625:b0:b9b:5fee:4d51 with SMTP id
 a640c23a62f3a-b9c157159f5mr151974566b.10.1775034653700; Wed, 01 Apr 2026
 02:10:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260331235111.9FD2EC19423@smtp.kernel.org>
In-Reply-To: <20260331235111.9FD2EC19423@smtp.kernel.org>
From: Li Wang <liwang@redhat.com>
Date: Wed, 1 Apr 2026 17:10:39 +0800
X-Gm-Features: AQROBzC68xg9YjXgX5VPKG6bMdUF4_tDuTaI8-15733PK55F1xntex7UvqdHG1k
Message-ID: <CAEemH2dhQajneEuXMYom=1Jt7CV2OJ49Uuf-O86btGQrsi=AaQ@mail.gmail.com>
Subject: Re: + selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible.patch
 added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, david@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,

Just want you to know I sent a new version of this patch:
  https://lore.kernel.org/all/20260401090520.24018-1-liwang@redhat.com/

I noticed you already added v4 into -mm mm-new branch, and the v5
is requested by David to drop run_test() wrapper function, and code indent
adjustment.


--
Regards,
Li Wang

