Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02CB18A6A9
	for <mm-commits@vger.kernel.org>; Mon, 30 Dec 2024 22:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735596647; cv=none; b=NpoPYZ4jiVrNUqdZOP0yLACN9hfR7R6sGMVMxoNb4donX9WiCQdmewt23TMA+zz0J0GQ2nhg46pu4CPQ5QGjONxwRwEQ9Pb3iqKNieVMhQVcrjDWTbDjU+Ds0jB4DtP2e7WGBiX5sdOEl7UoK42/JAVlI8aYVSoVDb4hlPzWY7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735596647; c=relaxed/simple;
	bh=5LJzJ/oiEnPwt2t9vgKLMDYJEypz6IGgLu1Z7T73Fno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uw8bqLIbXv1/tRTN2TnwVIjhbX74NspONQl/BVblJfXf19bhlgJNQXSpdC5WoMnpXVYxif59Nx0txfSVe5I8EWxaPoqhpaccVPTyodFyUM1hAvxqoS//aP6VC/0HPdRbZstdDvyLH+YJOZhZ5xxvZcXxdU/OXEII9eFK+WMi6Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWO8CxqW; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWO8CxqW"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f441791e40so10384892a91.3
        for <mm-commits@vger.kernel.org>; Mon, 30 Dec 2024 14:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735596645; x=1736201445; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NRR0nC5Rjqn4MyVu+bMQjAc207+q7TTZ+4mX/ECc7oQ=;
        b=OWO8CxqWtv91Ssj4r6XXzYC1El3yzdw+c2augXxwHB/eUB67i0NPRl1FdJBPRWxQDs
         0W4Yd8/fEZA7TXzgRw5zdneyftxeGjC1eOcrTBplny1VWzcBoYxgBUx7MXs26/IHNafL
         Gc/YcYolDG6xDcMk6NqaGIiwjnTwSW5ar1/AjY1y16EzRdOYLWzWoO4KoLIGAy7i7G3u
         XFxlA7DN4hyzqaojNuwcX6QBV+wGFU2Jp+A1kmk7nIHxWXSRLk3T+2+X2TT8633Jj+tk
         oNEWrPFP7xthc+k6Tycb7Uhmz66OwHJ4RsvX6Euc2wTj8+9cc6oMsHqBJ5PBEtmLM1w7
         6e1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735596645; x=1736201445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NRR0nC5Rjqn4MyVu+bMQjAc207+q7TTZ+4mX/ECc7oQ=;
        b=dPN36A1bZNYvSddPp/RUwA74RMVzciG6eCXaPYa2SDR62kYr6hEl2LFFMDc1T1gVib
         MsEktyEV3QiC4fIKr68bU0nC/2nJiN6crg7lQ70hcwtBVuwbqOBFs+46Akbqb+JmFIds
         hwnWwWyVV+9bdk+k0RYwbQJrkQjsnFKcVgIVK6P0sTWkvNqaEjrrh/Zl6rr2j057sY7e
         0NZVg17IJrFRahoGgkMF/Z4T/SF3J9Zc6rz8uPKdS9xg/6HEGBIDPHC0dvGcKN/kbpcF
         w6Cg6K3UWEQkh1nE/40JuYVTKDpXyQKGf3CBI+7I79/0pYkiTWT2PUO8OTwcM6nYnf+/
         F6Xw==
X-Gm-Message-State: AOJu0YxsFThhA2XpXXSOEpLPvfIV7vonZ/+YVww0t3PFeVZCvlF1/RxW
	lJrXPl4nYgUGVYDWPhacvozO4bWi3yl7YrwPv5kO3jQAdDyD3riMaLIgrNHK
X-Gm-Gg: ASbGncsKExqn23ljgSdhPt2CYSs31VDI/OPZfZDlmGh7yF+pudqGFpE0uUXWOdfnqXV
	6px1TRxx0ak+vG9PcvPYO27zjmSZT2EEv26JMC17W48hcsKvVq9mOviG2nlU5jhV6q1FdSjcLbK
	HhII4Hz4g/V0ttJ0zdr1IYf1ADVGqYpetouRPYkP8c4NiVE/FoWwYWAajs8FTySGcksc1Tf1B/b
	0PyNjIpW/4CAym2GAFh5iXVzzYPLeOVTFx7I++k9YM/3FQQpTHwMkXLbNPt+LrP1NI1OpUNBKJs
	KcrIvFJx
X-Google-Smtp-Source: AGHT+IFwSk/Sf3wzIXtHX6CoDaMXnP+jFRbgAawCapDoofRZPNr/xl0ICq1fkmInNjtPOUdR0OCB+g==
X-Received: by 2002:a17:90b:538b:b0:2f2:a796:26b with SMTP id 98e67ed59e1d1-2f452dfaf91mr52496759a91.1.1735596644790;
        Mon, 30 Dec 2024 14:10:44 -0800 (PST)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962cb8sm183704375ad.10.2024.12.30.14.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 14:10:43 -0800 (PST)
Date: Tue, 31 Dec 2024 06:10:39 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, jserv@ccns.ncku.edu.tw,
	chuang@cs.nycu.edu.tw
Subject: Re: +
 lib-list_sort-clarify-comparison-function-requirements-in-sort_r.patch added
 to mm-nonmm-unstable branch
Message-ID: <Z3MaX0fvKHHRYpUA@visitorckw-System-Product-Name>
References: <20241226221423.A3ACEC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241226221423.A3ACEC4CED1@smtp.kernel.org>

Hi Andrew,

On Thu, Dec 26, 2024 at 02:14:23PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: lib/list_sort: clarify comparison function requirements in sort_r()

Sorry for the typo in the patch subject title.
The sort_r() should be list_sort().

Is this small enough for you to fix directly, or should I resend the
patch series?

Regards,
Kuan-Wei
