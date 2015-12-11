From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + include-linux-propertyh-fix-build-issues-with-gcc-444.patch
 added to -mm tree
Date: Fri, 11 Dec 2015 09:58:08 -0800
Message-ID: <20151211095808.82df2854.akpm@linux-foundation.org>
References: <566a1edc.Xj1yIp5QNObaPriO%akpm@linux-foundation.org>
	<1449830574.30729.106.camel@linux.intel.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbbLKR6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 12:58:17 -0500
In-Reply-To: <1449830574.30729.106.camel@linux.intel.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: heikki.krogerus@linux.intel.com, kevin@scrye.com, mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org

On Fri, 11 Dec 2015 12:42:54 +0200 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> > __#define PROPERTY_ENTRY_INTEGER_ARRAY(_name_, _type_, _val_)	\
> > __{								\
> > __	.name = _name_,						
> > \
> > __	.length = ARRAY_SIZE(_val_) * sizeof(_type_),		
> > \
> > __	.is_array = true,					\
> > -	.pointer._type_##_data = _val_,				
> > \
> > +	.is_string = false,					\
> > +	{ .pointer = _type_##_data = _val_ } },			
> 
> This line looks suspicious now. Shouldn't be
> 
> { .pointer = { ._type_##_data = _val_ } },	

yup, thanks.  Stupid macros.

It tooks me ages to work out this workaround.  The secret is to have
the immediately preceding field (is_string) explicitly menationed.

