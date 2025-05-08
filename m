Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D8928A721
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733205; cv=none; b=K/lGYjXjzPho/ldN9DjbLXa3PE0rVWWtjI61LScUFWr+jMMsYCE36dHKkpiB22JXHU+mxUQ/6oN3b7X0uWF2KUBMt61+RbJQjSmxsitcwszsQbtJdlWxXaE30cK+yo6tLwLVQIcGWMUB+KJYeCWDz4LYIVP6SoBLk7C4tP2Wwww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733205; c=relaxed/simple;
	bh=e8w8pbtOwox1n0xvbW7dQYBWBMULKyzJf7Z4A787xeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RELZiWDDbjqF/5dCbgIED3yjXJH2N4x5LNhvUFCiBpxrTh5Imf9S5flc7sbUGrnb/IjtQ3/+ggquO/BsyIaUF62Exk1/gvDhEk+VDfqb+DcP2W0FW4Ziam0OPTG3Ue6hI/LLWPGpDf/uCmyJbG6Bvy1POZQydTDRW0756ec3wDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MNc9Zwwq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MNc9Zwwq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746733202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DiI+SWxp2LqztccBxjbFyPT2TUcaUx+SkQNIxGexkKU=;
	b=MNc9Zwwq+6cTJ7tC/u+XdDE0xoNaYMf7fuVnJI/XefKsvxu4m45yafBtJT4Xad/XpYbR9n
	4GD+KY5q6D6LOIe9QgOw6UfTCq3YjCpLPrz8pdLIUrlDwPmT7jyA2gKkZp6CqeIAoE9LMz
	FeN04Gtv/9BBsuD2CWNrs3r7Cwf/AEs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-ccOv4-WGOK2Q4gLZ-BS1Hg-1; Thu, 08 May 2025 15:40:01 -0400
X-MC-Unique: ccOv4-WGOK2Q4gLZ-BS1Hg-1
X-Mimecast-MFC-AGG-ID: ccOv4-WGOK2Q4gLZ-BS1Hg_1746733201
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e8f99a9524so41874326d6.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746733201; x=1747338001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DiI+SWxp2LqztccBxjbFyPT2TUcaUx+SkQNIxGexkKU=;
        b=jxgRNY1mY/SSU1AI6Fw2kt1dRGs9QlEoaZjoSGYhH5oPfPfT7T2DBDXTCF/oPVZgRS
         CiJiSEYp7TtLNmxVq5LCEPmC9bq43p4Ko7hMkoK9K5NvEGOEfFtLcQnWaaTCHrcPL51i
         IuGxhOyE9o+25UO9ppIeBs1oxtCI/0+9PhA1B6KOlg+THvi1P+UElzNbLGjLcZ/uDCK0
         1pAnlzdiEqMd3aQN+cliUtk5RMVr4AlB0z9LTmf1oxfmYiym7gvPucvJtNMCEXbD36KH
         SS2EKirTu/dDSSufk/Wm9cRCJfLpGZrebIWpaKjmxrDvr+NdxFlRVj1Hta2lZXdkhfV6
         3Zyg==
X-Forwarded-Encrypted: i=1; AJvYcCWcEBekD0NBlLHerNhI/aI8uXsYhXyjiiEDQm6JRT80yDvNR9ZDFM+fO7RLC6EFdldG+cr2atvrP0ZU@vger.kernel.org
X-Gm-Message-State: AOJu0YwxZbjS3wWlehvoIcjRdzICx6705GoNew8TNYK9AefPQFtVIE9I
	qmo0Ng3gdG1wj53hB74M7lEIKCDtMkojDwDu+w0VRlQWS6au8PYH9jvS5ntBd08qAyWg8Bxosci
	nnrE8KR6Hl8O6QU+sqhnxtYvoT+fOA3W9pkWUcy6CvKULA4mWZjgu+Te7cto=
X-Gm-Gg: ASbGncu9xH9dGhXtl6udlJBqPD6p22qipIVozVz234WMbs3B2/78UgU21G0Vk856i16
	j0RCCzNiGmEKT2G0M/IE0MAcA5T+FHX+FegGqcMN5uf+JKAxoGT3AJFtWScZY3N9ZxyIfCay517
	Xz4D/Az4vqSwsoQ1lZkS8lD4Y41WiJagqMJ9ooyT1iZ9Yz2oUD++7KCAaYsUmze6MlKpW4Zf8d9
	5Xd6qS8g7Rz7CQlPIOa0haPAzDDZGl46F8A/pliP6TLyn+SIr9i73fIrqmgx00SIZEZBep1Ep+T
	1Uc=
X-Received: by 2002:ad4:5ce2:0:b0:6e8:9b26:8c5 with SMTP id 6a1803df08f44-6f6e47f35c5mr8899816d6.10.1746733200796;
        Thu, 08 May 2025 12:40:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFE+KhA1VnZuW3v/tsg+mJ2h0mh6M22Gu79K4Q57jn+2DLDj7hevDMFFk2EL2vwM/lvpRkuBQ==
X-Received: by 2002:ad4:5ce2:0:b0:6e8:9b26:8c5 with SMTP id 6a1803df08f44-6f6e47f35c5mr8899476d6.10.1746733200464;
        Thu, 08 May 2025 12:40:00 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e39e066bsm3522276d6.24.2025.05.08.12.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:39:59 -0700 (PDT)
Date: Thu, 8 May 2025 15:39:56 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>,
	Pantelis Antoniou <p.antoniou@partner.samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aB0IjHLKnxk_opq0@x1.local>
References: <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca>
 <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com>
 <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
 <aB0BI-inU839lcIq@x1.local>
 <20250508191215.GB138689@ziepe.ca>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508191215.GB138689@ziepe.ca>

On Thu, May 08, 2025 at 04:12:15PM -0300, Jason Gunthorpe wrote:
> AFAIK KVM is doing this wonky thing using mmu notifiers, it doesn't
> take page references on pte special pages..

I checked the latest, I think you're right at least on the latest master
branch..  IIUC it's behavior on refcounting changed only last year after
Sean's 3dd48ecfac7f ("KVM: Provide refcounted page as output field in
struct kvm_follow_pfn").

To me, taking the refcount has one tiny little "benefit" of avoiding the
UAF you mentioned in the other email.  But I agree the whole thing is still
pretty wonky.

-- 
Peter Xu

